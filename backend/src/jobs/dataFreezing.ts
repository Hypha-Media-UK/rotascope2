/**
 * Data Freezing Job
 * 
 * This job runs at 07:59 AM daily to "freeze" the current day's schedule data.
 * This ensures that any changes made during night shifts are captured before
 * the day shift begins.
 * 
 * The freezing process:
 * 1. Creates a snapshot of the current day's porter assignments
 * 2. Records which porters are active on their shifts
 * 3. Captures temporary assignments that are in effect
 * 4. Marks the day as "frozen" to prevent further automatic changes
 */

import mysql from 'mysql2/promise'
import { dbConfig } from '../config/database'

interface FrozenScheduleData {
  date: string;
  departments: any[];
  services: any[];
  active_shifts: any[];
  frozen_at: string;
}

export class DataFreezingJob {
  private static instance: DataFreezingJob;
  private isRunning = false;
  private scheduledTimeout: NodeJS.Timeout | null = null;

  static getInstance(): DataFreezingJob {
    if (!DataFreezingJob.instance) {
      DataFreezingJob.instance = new DataFreezingJob();
    }
    return DataFreezingJob.instance;
  }

  /**
   * Start the data freezing scheduler
   */
  start(): void {
    console.log('🕐 Data Freezing Job: Starting scheduler...');
    this.scheduleNextRun();
  }

  /**
   * Stop the data freezing scheduler
   */
  stop(): void {
    if (this.scheduledTimeout) {
      clearTimeout(this.scheduledTimeout);
      this.scheduledTimeout = null;
    }
    console.log('🛑 Data Freezing Job: Scheduler stopped');
  }

  /**
   * Schedule the next run at 07:59 AM
   */
  private scheduleNextRun(): void {
    const now = new Date();
    const next759AM = new Date();
    
    // Set to 07:59 AM today
    next759AM.setHours(7, 59, 0, 0);
    
    // If it's already past 07:59 AM today, schedule for tomorrow
    if (now >= next759AM) {
      next759AM.setDate(next759AM.getDate() + 1);
    }
    
    const msUntilNext = next759AM.getTime() - now.getTime();
    
    console.log(`⏰ Data Freezing Job: Next run scheduled for ${next759AM.toLocaleString()}`);
    
    this.scheduledTimeout = setTimeout(() => {
      this.runFreezingJob();
      this.scheduleNextRun(); // Schedule the next day
    }, msUntilNext);
  }

  /**
   * Run the data freezing job manually (for testing)
   */
  async runManually(date?: string): Promise<void> {
    const targetDate = date || new Date().toISOString().split('T')[0];
    console.log(`🧊 Data Freezing Job: Running manually for date ${targetDate}`);
    await this.freezeScheduleData(targetDate);
  }

  /**
   * Main job execution
   */
  private async runFreezingJob(): Promise<void> {
    if (this.isRunning) {
      console.log('⚠️  Data Freezing Job: Already running, skipping...');
      return;
    }

    this.isRunning = true;
    const today = new Date().toISOString().split('T')[0];
    
    try {
      console.log(`🧊 Data Freezing Job: Starting for date ${today}`);
      await this.freezeScheduleData(today);
      console.log(`✅ Data Freezing Job: Completed successfully for ${today}`);
    } catch (error) {
      console.error(`❌ Data Freezing Job: Failed for ${today}:`, error);
    } finally {
      this.isRunning = false;
    }
  }

  /**
   * Freeze schedule data for a specific date
   */
  private async freezeScheduleData(date: string): Promise<void> {
    const connection = await mysql.createConnection(dbConfig);
    
    try {
      await connection.beginTransaction();

      // Check if this date is already frozen
      const [existingFrozen] = await connection.execute(
        'SELECT id FROM frozen_schedules WHERE date = ?',
        [date]
      );

      if ((existingFrozen as any[]).length > 0) {
        console.log(`📅 Date ${date} is already frozen, skipping...`);
        await connection.rollback();
        return;
      }

      // Get complete schedule data for the date
      const scheduleData = await this.getScheduleData(connection, date);
      
      // Create frozen schedule record
      const [result] = await connection.execute(
        `INSERT INTO frozen_schedules (date, schedule_data, frozen_at) VALUES (?, ?, NOW())`,
        [date, JSON.stringify(scheduleData)]
      );

      const frozenId = (result as any).insertId;

      // Create individual frozen porter assignments for easier querying
      for (const shift of scheduleData.active_shifts) {
        for (const assignment of shift.assigned_porters) {
          await connection.execute(
            `INSERT INTO frozen_porter_assignments 
             (frozen_schedule_id, porter_id, shift_id, is_active_today, is_temporarily_assigned, temp_assignment_location)
             VALUES (?, ?, ?, ?, ?, ?)`,
            [
              frozenId,
              assignment.porter.id,
              shift.shift.id,
              assignment.is_active_today ? 1 : 0,
              assignment.is_temporarily_assigned ? 1 : 0,
              assignment.temp_assignment_location || null
            ]
          );
        }
      }

      await connection.commit();
      console.log(`✅ Successfully froze schedule data for ${date} (ID: ${frozenId})`);
      
    } catch (error) {
      await connection.rollback();
      throw error;
    } finally {
      await connection.end();
    }
  }

  /**
   * Get complete schedule data for a date (same as API endpoint)
   */
  private async getScheduleData(connection: mysql.Connection, date: string): Promise<FrozenScheduleData> {
    const targetDate = new Date(date);
    
    // Get departments and services
    const [departments] = await connection.execute('SELECT * FROM departments WHERE is_active = 1 ORDER BY name');
    const [services] = await connection.execute('SELECT * FROM services WHERE is_active = 1 ORDER BY name');
    
    // Get shifts and calculate which are active
    const [shifts] = await connection.execute('SELECT * FROM shifts WHERE is_active = 1');
    const activeShifts = (shifts as any[]).filter(shift => this.calculateActiveShift(targetDate, shift));
    
    // Get porters with their assignments
    const [porters] = await connection.execute(`
      SELECT 
        p.*,
        s.name as shift_name, s.shift_type, s.shift_identifier, s.starts_at, s.ends_at,
        s.days_on, s.days_off, s.shift_offset, s.ground_zero_date,
        d1.name as regular_department_name,
        d2.name as temp_department_name,
        sv.name as temp_service_name
      FROM porters p
      LEFT JOIN shifts s ON p.shift_id = s.id
      LEFT JOIN departments d1 ON p.regular_department_id = d1.id
      LEFT JOIN departments d2 ON p.temp_department_id = d2.id
      LEFT JOIN services sv ON p.temp_service_id = sv.id
      WHERE p.is_active = 1
    `);
    
    // Build active shifts with assigned porters
    const activeShiftsWithPorters = activeShifts.map(shift => {
      const assignedPorters = (porters as any[])
        .filter(porter => porter.shift_id === shift.id)
        .map(porter => {
          const isActiveToday = this.calculatePorterActiveShift(targetDate, porter, shift);
          let isTemporarilyAssigned = false;
          let tempAssignmentLocation = null;
          
          // Check temporary assignment
          if (porter.temp_assignment_start && porter.temp_assignment_end) {
            const startDate = new Date(porter.temp_assignment_start);
            const endDate = new Date(porter.temp_assignment_end);
            if (targetDate >= startDate && targetDate <= endDate) {
              isTemporarilyAssigned = true;
              tempAssignmentLocation = porter.temp_department_name || porter.temp_service_name;
            }
          }
          
          return {
            porter,
            is_active_today: isActiveToday,
            is_temporarily_assigned: isTemporarilyAssigned,
            temp_assignment_location: tempAssignmentLocation
          };
        });
      
      return {
        shift,
        assigned_porters: assignedPorters,
        is_active_today: true
      };
    });
    
    return {
      date,
      departments: departments as any[],
      services: services as any[],
      active_shifts: activeShiftsWithPorters,
      frozen_at: new Date().toISOString()
    };
  }

  /**
   * Calculate if a shift is active on a given date
   */
  private calculateActiveShift(date: Date, shift: any): boolean {
    const groundZero = new Date(shift.ground_zero_date);
    const daysDiff = Math.floor((date.getTime() - groundZero.getTime()) / (1000 * 60 * 60 * 24));
    const adjustedDays = daysDiff + shift.shift_offset;
    const cycleLength = shift.days_on + shift.days_off;
    const cyclePosition = adjustedDays % cycleLength;
    return cyclePosition >= 0 && cyclePosition < shift.days_on;
  }

  /**
   * Calculate if a porter is active on their shift for a given date
   */
  private calculatePorterActiveShift(date: Date, porter: any, shift: any): boolean {
    const porterGroundZero = new Date(shift.ground_zero_date);
    porterGroundZero.setDate(porterGroundZero.getDate() + (porter.porter_offset || 0));
    
    const daysDiff = Math.floor((date.getTime() - porterGroundZero.getTime()) / (1000 * 60 * 60 * 24));
    const cycleLength = shift.days_on + shift.days_off;
    const cyclePosition = daysDiff % cycleLength;
    return cyclePosition >= 0 && cyclePosition < shift.days_on;
  }
}

// Export singleton instance
export const dataFreezingJob = DataFreezingJob.getInstance();
