"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.dataFreezingJob = exports.DataFreezingJob = void 0;
const promise_1 = __importDefault(require("mysql2/promise"));
const database_1 = require("../config/database");
class DataFreezingJob {
    constructor() {
        this.isRunning = false;
        this.scheduledTimeout = null;
    }
    static getInstance() {
        if (!DataFreezingJob.instance) {
            DataFreezingJob.instance = new DataFreezingJob();
        }
        return DataFreezingJob.instance;
    }
    start() {
        console.log('🕐 Data Freezing Job: Starting scheduler...');
        this.scheduleNextRun();
    }
    stop() {
        if (this.scheduledTimeout) {
            clearTimeout(this.scheduledTimeout);
            this.scheduledTimeout = null;
        }
        console.log('🛑 Data Freezing Job: Scheduler stopped');
    }
    scheduleNextRun() {
        const now = new Date();
        const next759AM = new Date();
        next759AM.setHours(7, 59, 0, 0);
        if (now >= next759AM) {
            next759AM.setDate(next759AM.getDate() + 1);
        }
        const msUntilNext = next759AM.getTime() - now.getTime();
        console.log(`⏰ Data Freezing Job: Next run scheduled for ${next759AM.toLocaleString()}`);
        this.scheduledTimeout = setTimeout(() => {
            this.runFreezingJob();
            this.scheduleNextRun();
        }, msUntilNext);
    }
    async runManually(date) {
        const targetDate = date || new Date().toISOString().split('T')[0];
        console.log(`🧊 Data Freezing Job: Running manually for date ${targetDate}`);
        await this.freezeScheduleData(targetDate);
    }
    async runFreezingJob() {
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
        }
        catch (error) {
            console.error(`❌ Data Freezing Job: Failed for ${today}:`, error);
        }
        finally {
            this.isRunning = false;
        }
    }
    async freezeScheduleData(date) {
        const connection = await promise_1.default.createConnection(database_1.dbConfig);
        try {
            await connection.beginTransaction();
            const [existingFrozen] = await connection.execute('SELECT id FROM frozen_schedules WHERE date = ?', [date]);
            if (existingFrozen.length > 0) {
                console.log(`📅 Date ${date} is already frozen, skipping...`);
                await connection.rollback();
                return;
            }
            const scheduleData = await this.getScheduleData(connection, date);
            const [result] = await connection.execute(`INSERT INTO frozen_schedules (date, schedule_data, frozen_at) VALUES (?, ?, NOW())`, [date, JSON.stringify(scheduleData)]);
            const frozenId = result.insertId;
            for (const shift of scheduleData.active_shifts) {
                for (const assignment of shift.assigned_porters) {
                    await connection.execute(`INSERT INTO frozen_porter_assignments 
             (frozen_schedule_id, porter_id, shift_id, is_active_today, is_temporarily_assigned, temp_assignment_location)
             VALUES (?, ?, ?, ?, ?, ?)`, [
                        frozenId,
                        assignment.porter.id,
                        shift.shift.id,
                        assignment.is_active_today ? 1 : 0,
                        assignment.is_temporarily_assigned ? 1 : 0,
                        assignment.temp_assignment_location || null
                    ]);
                }
            }
            await connection.commit();
            console.log(`✅ Successfully froze schedule data for ${date} (ID: ${frozenId})`);
        }
        catch (error) {
            await connection.rollback();
            throw error;
        }
        finally {
            await connection.end();
        }
    }
    async getScheduleData(connection, date) {
        const targetDate = new Date(date);
        const [departments] = await connection.execute('SELECT * FROM departments WHERE is_active = 1 ORDER BY name');
        const [services] = await connection.execute('SELECT * FROM services WHERE is_active = 1 ORDER BY name');
        const [shifts] = await connection.execute('SELECT * FROM shifts WHERE is_active = 1');
        const activeShifts = shifts.filter(shift => this.calculateActiveShift(targetDate, shift));
        const [porters] = await connection.execute(`
      SELECT
        p.*,
        s.name as shift_name, s.shift_type_id, s.starts_at, s.ends_at,
        s.days_on, s.days_off, s.shift_offset, s.ground_zero_date,
        st.name as shift_type_name, st.display_type, st.color,
        d1.name as regular_department_name,
        d2.name as temp_department_name,
        sv.name as temp_service_name
      FROM porters p
      LEFT JOIN shifts s ON p.shift_id = s.id
      LEFT JOIN shift_types st ON s.shift_type_id = st.id
      LEFT JOIN departments d1 ON p.regular_department_id = d1.id
      LEFT JOIN departments d2 ON p.temp_department_id = d2.id
      LEFT JOIN services sv ON p.temp_service_id = sv.id
      WHERE p.is_active = 1
    `);
        const activeShiftsWithPorters = activeShifts.map(shift => {
            const assignedPorters = porters
                .filter(porter => porter.shift_id === shift.id)
                .map(porter => {
                const isActiveToday = this.calculatePorterActiveShift(targetDate, porter, shift);
                let isTemporarilyAssigned = false;
                let tempAssignmentLocation = null;
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
            departments: departments,
            services: services,
            active_shifts: activeShiftsWithPorters,
            frozen_at: new Date().toISOString()
        };
    }
    calculateActiveShift(date, shift) {
        const groundZero = new Date(shift.ground_zero_date);
        const daysDiff = Math.floor((date.getTime() - groundZero.getTime()) / (1000 * 60 * 60 * 24));
        const adjustedDays = daysDiff + shift.shift_offset;
        const cycleLength = shift.days_on + shift.days_off;
        const cyclePosition = adjustedDays % cycleLength;
        return cyclePosition >= 0 && cyclePosition < shift.days_on;
    }
    calculatePorterActiveShift(date, porter, shift) {
        const porterGroundZero = new Date(shift.ground_zero_date);
        porterGroundZero.setDate(porterGroundZero.getDate() + (porter.porter_offset || 0));
        const daysDiff = Math.floor((date.getTime() - porterGroundZero.getTime()) / (1000 * 60 * 60 * 24));
        const cycleLength = shift.days_on + shift.days_off;
        const cyclePosition = daysDiff % cycleLength;
        return cyclePosition >= 0 && cyclePosition < shift.days_on;
    }
}
exports.DataFreezingJob = DataFreezingJob;
exports.dataFreezingJob = DataFreezingJob.getInstance();
//# sourceMappingURL=dataFreezing.js.map