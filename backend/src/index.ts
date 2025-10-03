// Porter Tracking System - Main Application Entry Point
import express from 'express';
import cors from 'cors';
import mysql from 'mysql2/promise'
import { dataFreezingJob } from './jobs/dataFreezing';

// Simple database test
const dbConfig = {
  host: 'localhost',
  port: 3307,
  user: 'rotascope_user',
  password: 'rotascope_password',
  database: 'rotascope'
};

async function testConnection() {
  try {
    const connection = await mysql.createConnection(dbConfig);
    await connection.ping();
    await connection.end();
    console.log('✅ Database connection successful');
    return true;
  } catch (error) {
    console.error('❌ Database connection failed:', error);
    return false;
  }
}

const app = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(express.json());

// Basic middleware
app.use(cors());
app.use(express.json());

// Simple test routes
app.get('/health', (req, res) => {
  res.json({
    status: 'OK',
    timestamp: new Date().toISOString(),
    version: '2.0.0'
  });
});

// Departments endpoints
app.get('/api/departments', async (req, res) => {
  try {
    const connection = await mysql.createConnection(dbConfig);
    const [departments] = await connection.execute('SELECT * FROM departments WHERE is_active = 1 ORDER BY name');
    await connection.end();
    res.json(departments);
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Database error' });
  }
});

app.post('/api/departments', async (req, res) => {
  try {
    const { name, is_24_7, porters_required_day, porters_required_night } = req.body;

    if (!name || porters_required_day < 1 || porters_required_night < 1) {
      return res.status(400).json({ error: 'Invalid department data' });
    }

    const connection = await mysql.createConnection(dbConfig);
    const [result] = await connection.execute(
      'INSERT INTO departments (name, code, is_24_7, porters_required_day, porters_required_night, is_active) VALUES (?, ?, ?, ?, ?, 1)',
      [name, name.toUpperCase().replace(/\s+/g, ''), is_24_7 ? 1 : 0, porters_required_day, porters_required_night]
    );
    await connection.end();

    return res.status(201).json({ id: (result as any).insertId, message: 'Department created successfully' });
  } catch (error: any) {
    console.error('Error creating department:', error);

    // Handle specific MySQL errors
    if (error.code === 'ER_DUP_ENTRY') {
      if (error.message.includes('name')) {
        return res.status(400).json({ error: 'A department with this name already exists' });
      } else if (error.message.includes('code')) {
        return res.status(400).json({ error: 'A department with a similar name already exists' });
      } else {
        return res.status(400).json({ error: 'Department name must be unique' });
      }
    }

    return res.status(500).json({ error: 'Failed to create department' });
  }
});

app.put('/api/departments/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { name, is_24_7, porters_required_day, porters_required_night } = req.body;

    if (!name || porters_required_day < 1 || porters_required_night < 1) {
      return res.status(400).json({ error: 'Invalid department data' });
    }

    const connection = await mysql.createConnection(dbConfig);
    await connection.execute(
      'UPDATE departments SET name = ?, code = ?, is_24_7 = ?, porters_required_day = ?, porters_required_night = ?, updated_at = NOW() WHERE id = ?',
      [name, name.toUpperCase().replace(/\s+/g, ''), is_24_7 ? 1 : 0, porters_required_day, porters_required_night, id]
    );
    await connection.end();

    return res.json({ message: 'Department updated successfully' });
  } catch (error: any) {
    console.error('Error updating department:', error);

    // Handle specific MySQL errors
    if (error.code === 'ER_DUP_ENTRY') {
      if (error.message.includes('name')) {
        return res.status(400).json({ error: 'A department with this name already exists' });
      } else if (error.message.includes('code')) {
        return res.status(400).json({ error: 'A department with a similar name already exists' });
      } else {
        return res.status(400).json({ error: 'Department name must be unique' });
      }
    }

    return res.status(500).json({ error: 'Failed to update department' });
  }
});

app.delete('/api/departments/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const connection = await mysql.createConnection(dbConfig);
    await connection.execute('UPDATE departments SET is_active = 0, updated_at = NOW() WHERE id = ?', [id]);
    await connection.end();

    res.json({ message: 'Department deleted successfully' });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Database error' });
  }
});

app.get('/api/services', async (req, res) => {
  try {
    const connection = await mysql.createConnection(dbConfig);
    const [services] = await connection.execute('SELECT * FROM services WHERE is_active = 1 ORDER BY name');
    await connection.end();
    res.json(services);
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Database error' });
  }
});

app.post('/api/services', async (req, res) => {
  try {
    const { name, code, is_24_7, porters_required_day, porters_required_night } = req.body;

    if (!name || porters_required_day < 1 || porters_required_night < 1) {
      return res.status(400).json({ error: 'Invalid service data' });
    }

    const serviceCode = code || name.toUpperCase().replace(/\s+/g, '').substring(0, 10);

    const connection = await mysql.createConnection(dbConfig);
    const [result] = await connection.execute(
      'INSERT INTO services (name, code, is_24_7, porters_required_day, porters_required_night, is_active) VALUES (?, ?, ?, ?, ?, 1)',
      [name, serviceCode, is_24_7 ? 1 : 0, porters_required_day, porters_required_night]
    );
    await connection.end();

    return res.status(201).json({ id: (result as any).insertId, message: 'Service created successfully' });
  } catch (error) {
    console.error('Error:', error);
    return res.status(500).json({ error: 'Database error' });
  }
});

app.put('/api/services/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { name, code, is_24_7, porters_required_day, porters_required_night } = req.body;

    if (!name || porters_required_day < 1 || porters_required_night < 1) {
      return res.status(400).json({ error: 'Invalid service data' });
    }

    const serviceCode = code || name.toUpperCase().replace(/\s+/g, '').substring(0, 10);

    const connection = await mysql.createConnection(dbConfig);
    await connection.execute(
      'UPDATE services SET name = ?, code = ?, is_24_7 = ?, porters_required_day = ?, porters_required_night = ?, updated_at = NOW() WHERE id = ?',
      [name, serviceCode, is_24_7 ? 1 : 0, porters_required_day, porters_required_night, id]
    );
    await connection.end();

    return res.json({ message: 'Service updated successfully' });
  } catch (error) {
    console.error('Error:', error);
    return res.status(500).json({ error: 'Database error' });
  }
});

app.delete('/api/services/:id', async (req, res) => {
  try {
    const { id } = req.params;

    const connection = await mysql.createConnection(dbConfig);
    await connection.execute('UPDATE services SET is_active = 0, updated_at = NOW() WHERE id = ?', [id]);
    await connection.end();

    return res.json({ message: 'Service deleted successfully' });
  } catch (error) {
    console.error('Error:', error);
    return res.status(500).json({ error: 'Database error' });
  }
});

app.get('/api/porters', async (req, res) => {
  try {
    const connection = await mysql.createConnection(dbConfig);
    const [porters] = await connection.execute('SELECT * FROM porters WHERE is_active = 1 ORDER BY name');
    await connection.end();
    res.json(porters);
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Database error' });
  }
});

app.get('/api/porters/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const connection = await mysql.createConnection(dbConfig);

    // Get porter with related data
    const [porters] = await connection.execute(`
      SELECT
        p.*,
        s.name as shift_name,
        rd.name as regular_department_name,
        rs.name as regular_service_name,
        td.name as temp_department_name,
        ts.name as temp_service_name
      FROM porters p
      LEFT JOIN shifts s ON p.shift_id = s.id
      LEFT JOIN departments rd ON p.regular_department_id = rd.id
      LEFT JOIN services rs ON p.regular_service_id = rs.id
      LEFT JOIN departments td ON p.temp_department_id = td.id
      LEFT JOIN services ts ON p.temp_service_id = ts.id
      WHERE p.id = ? AND p.is_active = 1
    `, [id]);

    if (!porters || (porters as any[]).length === 0) {
      await connection.end();
      return res.status(404).json({ error: 'Porter not found' });
    }

    const porter = (porters as any[])[0];

    // Get custom hours if porter has them
    let customHours: any[] = [];
    if (porter.has_custom_hours) {
      const [hours] = await connection.execute(
        'SELECT * FROM porter_hours WHERE porter_id = ? ORDER BY day_of_week, starts_at',
        [id]
      );
      customHours = hours as any[];
    }

    await connection.end();

    // Return porter with additional details structure expected by frontend
    const porterWithDetails = {
      ...porter,
      custom_hours: customHours,
      annual_leave: [], // Empty for now, can be populated later if needed
      sickness: [], // Empty for now
      absences: [], // Empty for now
      assignments: [] // Empty for now
    };

    return res.json(porterWithDetails);
  } catch (error) {
    console.error('Error:', error);
    return res.status(500).json({ error: 'Database error' });
  }
});

app.post('/api/porters', async (req, res) => {
  try {
    const {
      name, email, porter_type, weekly_contracted_hours, has_custom_hours,
      shift_id, porter_offset, regular_department_id, regular_service_id,
      temp_department_id, temp_service_id, temp_assignment_start, temp_assignment_end,
      is_active
    } = req.body;

    if (!name || !porter_type) {
      return res.status(400).json({ error: 'Missing required porter data' });
    }

    // Helper function to convert ISO datetime to MySQL date format
    const formatDateForDB = (dateString: string | null): string | null => {
      if (!dateString) return null;
      // Convert ISO datetime to YYYY-MM-DD format for MySQL date fields
      return dateString.split('T')[0];
    };

    const connection = await mysql.createConnection(dbConfig);
    const [result] = await connection.execute(
      `INSERT INTO porters (
        name, email, porter_type, weekly_contracted_hours, has_custom_hours,
        shift_id, porter_offset, regular_department_id, regular_service_id,
        temp_department_id, temp_service_id, temp_assignment_start, temp_assignment_end,
        is_active
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        name, email || null, porter_type, weekly_contracted_hours || 37.50, has_custom_hours ? 1 : 0,
        shift_id || null, porter_offset || 0, regular_department_id || null, regular_service_id || null,
        temp_department_id || null, temp_service_id || null,
        formatDateForDB(temp_assignment_start), formatDateForDB(temp_assignment_end),
        is_active ? 1 : 0
      ]
    );
    await connection.end();

    return res.status(201).json({ id: (result as any).insertId, message: 'Porter created successfully' });
  } catch (error) {
    console.error('Error creating porter:', error);
    return res.status(500).json({ error: 'Database error' });
  }
});

app.put('/api/porters/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const {
      name, email, porter_type, weekly_contracted_hours, has_custom_hours,
      shift_id, porter_offset, regular_department_id, regular_service_id,
      temp_department_id, temp_service_id, temp_assignment_start, temp_assignment_end,
      is_active
    } = req.body;

    if (!name || !porter_type) {
      return res.status(400).json({ error: 'Missing required porter data' });
    }

    // Helper function to convert ISO datetime to MySQL date format
    const formatDateForDB = (dateString: string | null): string | null => {
      if (!dateString) return null;
      // Convert ISO datetime to YYYY-MM-DD format for MySQL date fields
      return dateString.split('T')[0];
    };

    const connection = await mysql.createConnection(dbConfig);
    await connection.execute(
      `UPDATE porters SET
        name = ?, email = ?, porter_type = ?, weekly_contracted_hours = ?, has_custom_hours = ?,
        shift_id = ?, porter_offset = ?, regular_department_id = ?, regular_service_id = ?,
        temp_department_id = ?, temp_service_id = ?, temp_assignment_start = ?, temp_assignment_end = ?,
        is_active = ?, updated_at = NOW()
      WHERE id = ?`,
      [
        name, email || null, porter_type, weekly_contracted_hours || 37.50, has_custom_hours ? 1 : 0,
        shift_id || null, porter_offset || 0, regular_department_id || null, regular_service_id || null,
        temp_department_id || null, temp_service_id || null,
        formatDateForDB(temp_assignment_start), formatDateForDB(temp_assignment_end),
        is_active ? 1 : 0, id
      ]
    );
    await connection.end();

    return res.json({ message: 'Porter updated successfully' });
  } catch (error) {
    console.error('Error updating porter:', error);
    return res.status(500).json({ error: 'Database error' });
  }
});

app.delete('/api/porters/:id', async (req, res) => {
  try {
    const { id } = req.params;

    const connection = await mysql.createConnection(dbConfig);
    await connection.execute('UPDATE porters SET is_active = 0, updated_at = NOW() WHERE id = ?', [id]);
    await connection.end();

    return res.json({ message: 'Porter deleted successfully' });
  } catch (error) {
    console.error('Error:', error);
    return res.status(500).json({ error: 'Database error' });
  }
});

// Get porter hours
app.get('/api/porters/:id/hours', async (req, res) => {
  try {
    const { id } = req.params;
    const connection = await mysql.createConnection(dbConfig);
    const [rows] = await connection.execute(
      'SELECT * FROM porter_hours WHERE porter_id = ? ORDER BY day_of_week, starts_at',
      [id]
    );
    await connection.end();
    return res.json(rows);
  } catch (error) {
    console.error('Error fetching porter hours:', error);
    return res.status(500).json({ error: 'Database error' });
  }
});

// Update porter hours
app.put('/api/porters/:id/hours', async (req, res) => {
  try {
    const { id } = req.params;
    const { hours } = req.body;

    if (!Array.isArray(hours)) {
      return res.status(400).json({ error: 'Hours must be an array' });
    }

    const connection = await mysql.createConnection(dbConfig);

    // Start transaction
    await connection.beginTransaction();

    try {
      // Delete existing hours for this porter
      await connection.execute('DELETE FROM porter_hours WHERE porter_id = ?', [id]);

      // Insert new hours
      for (const hour of hours) {
        await connection.execute(
          'INSERT INTO porter_hours (porter_id, day_of_week, starts_at, ends_at) VALUES (?, ?, ?, ?)',
          [id, hour.day_of_week, hour.starts_at + ':00', hour.ends_at + ':00']
        );
      }

      await connection.commit();
      await connection.end();

      return res.json({ message: 'Porter hours updated successfully' });
    } catch (error) {
      await connection.rollback();
      await connection.end();
      throw error;
    }
  } catch (error) {
    console.error('Error updating porter hours:', error);
    return res.status(500).json({ error: 'Database error' });
  }
});

// Get comprehensive porter availability for a specific date
app.get('/api/availability/:date', async (req, res) => {
  try {
    const { date } = req.params;
    const targetDate = new Date(date);
    const dayOfWeek = targetDate.getDay(); // 0=Sunday, 1=Monday, etc.

    const connection = await mysql.createConnection(dbConfig);

    // Get all active porters with their assignments
    const [porters] = await connection.execute(`
      SELECT
        p.*,
        rd.name as regular_department_name,
        rs.name as regular_service_name,
        td.name as temp_department_name,
        ts.name as temp_service_name,
        s.name as shift_name,
        s.shift_type_id,
        st.name as shift_type_name,
        st.display_type,
        st.color,
        s.starts_at as shift_starts_at,
        s.ends_at as shift_ends_at,
        s.days_on,
        s.days_off,
        s.ground_zero_date
      FROM porters p
      LEFT JOIN departments rd ON p.regular_department_id = rd.id
      LEFT JOIN services rs ON p.regular_service_id = rs.id
      LEFT JOIN departments td ON p.temp_department_id = td.id
      LEFT JOIN services ts ON p.temp_service_id = ts.id
      LEFT JOIN shifts s ON p.shift_id = s.id
      LEFT JOIN shift_types st ON s.shift_type_id = st.id
      WHERE p.is_active = 1
      ORDER BY p.name
    `);

    // Get custom hours for all porters for this day of week
    const [customHours] = await connection.execute(`
      SELECT porter_id, starts_at, ends_at
      FROM porter_hours
      WHERE day_of_week = ?
    `, [dayOfWeek]);

    // Get departments and services
    const [departments] = await connection.execute('SELECT * FROM departments WHERE is_active = 1 ORDER BY name');
    const [services] = await connection.execute('SELECT * FROM services WHERE is_active = 1 ORDER BY name');
    const [shifts] = await connection.execute('SELECT * FROM shifts WHERE is_active = 1 ORDER BY name');

    await connection.end();

    // Create lookup for custom hours
    const customHoursMap = new Map();
    (customHours as any[]).forEach((hour: any) => {
      customHoursMap.set(hour.porter_id, {
        start: hour.starts_at,
        end: hour.ends_at
      });
    });

    const availablePorters: any[] = [];

    (porters as any[]).forEach((porter: any) => {
      const porterAvailability = calculatePorterAvailability(porter, targetDate, dayOfWeek, customHoursMap);
      if (porterAvailability) {
        availablePorters.push(porterAvailability);
      }
    });

    return res.json({
      date: date,
      available_porters: availablePorters,
      departments: departments,
      services: services,
      shifts: shifts
    });

  } catch (error) {
    console.error('Error fetching porter availability:', error);
    return res.status(500).json({ error: 'Database error' });
  }
});

// Helper function to calculate porter availability
function calculatePorterAvailability(porter: any, targetDate: Date, dayOfWeek: number, customHoursMap: Map<number, any>) {
  const isInTempAssignmentPeriod = porter.temp_assignment_start && porter.temp_assignment_end &&
    targetDate >= new Date(porter.temp_assignment_start) && targetDate <= new Date(porter.temp_assignment_end);

  // Priority 1: Temporary Assignment (highest priority)
  if (isInTempAssignmentPeriod) {
    if (porter.temp_department_id) {
      return createAvailabilityRecord(porter, 'DEPARTMENT', porter.temp_department_id, porter.temp_department_name, 'TEMPORARY');
    } else if (porter.temp_service_id) {
      return createAvailabilityRecord(porter, 'SERVICE', porter.temp_service_id, porter.temp_service_name, 'TEMPORARY');
    }
  }

  // Priority 2: Shift Assignment with location
  if (porter.shift_id && isPorterWorkingShiftToday(porter, targetDate, dayOfWeek)) {
    // Determine location for shift worker
    if (porter.regular_department_id) {
      return createAvailabilityRecord(porter, 'DEPARTMENT', porter.regular_department_id, porter.regular_department_name, 'REGULAR', 'SHIFT', porter);
    } else if (porter.regular_service_id) {
      return createAvailabilityRecord(porter, 'SERVICE', porter.regular_service_id, porter.regular_service_name, 'REGULAR', 'SHIFT', porter);
    }
  }

  // Priority 3: Custom Hours with regular assignment
  if (porter.contracted_hours_type === 'CUSTOM' && customHoursMap.has(porter.id)) {
    const hours = customHoursMap.get(porter.id);
    if (porter.regular_department_id) {
      return createAvailabilityRecord(porter, 'DEPARTMENT', porter.regular_department_id, porter.regular_department_name, 'REGULAR', 'CUSTOM_HOURS', null, hours);
    } else if (porter.regular_service_id) {
      return createAvailabilityRecord(porter, 'SERVICE', porter.regular_service_id, porter.regular_service_name, 'REGULAR', 'CUSTOM_HOURS', null, hours);
    }
  }

  // Priority 4: Regular Assignment (always available - for 24/7 departments/services)
  if (porter.regular_department_id) {
    return createAvailabilityRecord(porter, 'DEPARTMENT', porter.regular_department_id, porter.regular_department_name, 'REGULAR', 'REGULAR_ASSIGNMENT');
  } else if (porter.regular_service_id) {
    return createAvailabilityRecord(porter, 'SERVICE', porter.regular_service_id, porter.regular_service_name, 'REGULAR', 'REGULAR_ASSIGNMENT');
  }

  return null; // Porter not available today
}

function createAvailabilityRecord(porter: any, locationType: string, locationId: number, locationName: string, assignmentType: string, availabilityType: string = 'REGULAR_ASSIGNMENT', shiftInfo: any = null, customHours: any = null) {
  return {
    porter: {
      id: porter.id,
      name: porter.name,
      email: porter.email,
      porter_type: porter.porter_type,
      contracted_hours_type: porter.contracted_hours_type,
      weekly_contracted_hours: porter.weekly_contracted_hours,
      shift_id: porter.shift_id,
      porter_offset: porter.porter_offset,
      regular_department_id: porter.regular_department_id,
      regular_service_id: porter.regular_service_id,
      temp_department_id: porter.temp_department_id,
      temp_service_id: porter.temp_service_id,
      temp_assignment_start: porter.temp_assignment_start,
      temp_assignment_end: porter.temp_assignment_end,
      is_active: porter.is_active
    },
    availability_type: availabilityType,
    is_working_today: true,
    working_hours: customHours || (shiftInfo ? {
      start: shiftInfo.shift_starts_at,
      end: shiftInfo.shift_ends_at
    } : undefined),
    assignment_location: {
      type: locationType,
      id: locationId,
      name: locationName,
      assignment_type: assignmentType
    },
    shift_info: shiftInfo ? {
      shift_id: shiftInfo.shift_id,
      shift_name: shiftInfo.shift_name,
      shift_type_id: shiftInfo.shift_type_id,
      shift_type_name: shiftInfo.shift_type_name,
      display_type: shiftInfo.display_type,
      color: shiftInfo.color
    } : undefined
  };
}

function isPorterWorkingShiftToday(porter: any, targetDate: Date, dayOfWeek: number) {
  if (!porter.shift_id || !porter.ground_zero_date) return false;

  const groundZero = new Date(porter.ground_zero_date);
  const porterOffset = porter.porter_offset || 0;
  const adjustedGroundZero = new Date(groundZero.getTime() + (porterOffset * 24 * 60 * 60 * 1000));

  const daysDiff = Math.floor((targetDate.getTime() - adjustedGroundZero.getTime()) / (24 * 60 * 60 * 1000));
  const cycleLength = porter.days_on + porter.days_off;
  const positionInCycle = ((daysDiff % cycleLength) + cycleLength) % cycleLength;

  return positionInCycle < porter.days_on;
}

// ============================================================================
// SHIFT TYPES ENDPOINTS
// ============================================================================

app.get('/api/shift-types', async (req, res) => {
  try {
    const connection = await mysql.createConnection(dbConfig);
    const [shiftTypes] = await connection.execute('SELECT * FROM shift_types WHERE is_active = 1 ORDER BY name');
    await connection.end();
    res.json(shiftTypes);
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Database error' });
  }
});

app.post('/api/shift-types', async (req, res) => {
  try {
    const { name, starts_at, ends_at, display_type, color } = req.body;

    if (!name || !starts_at || !ends_at || !display_type) {
      return res.status(400).json({ error: 'Missing required shift type data' });
    }

    const connection = await mysql.createConnection(dbConfig);
    const [result] = await connection.execute(
      'INSERT INTO shift_types (name, starts_at, ends_at, display_type, color, is_active) VALUES (?, ?, ?, ?, ?, 1)',
      [name, starts_at, ends_at, display_type, color || null]
    );
    await connection.end();

    return res.status(201).json({ id: (result as any).insertId, message: 'Shift type created successfully' });
  } catch (error) {
    console.error('Error:', error);
    return res.status(500).json({ error: 'Database error' });
  }
});

app.put('/api/shift-types/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { name, starts_at, ends_at, display_type, color } = req.body;

    if (!name || !starts_at || !ends_at || !display_type) {
      return res.status(400).json({ error: 'Missing required shift type data' });
    }

    const connection = await mysql.createConnection(dbConfig);
    await connection.execute(
      'UPDATE shift_types SET name = ?, starts_at = ?, ends_at = ?, display_type = ?, color = ?, updated_at = NOW() WHERE id = ?',
      [name, starts_at, ends_at, display_type, color || null, id]
    );
    await connection.end();

    return res.json({ message: 'Shift type updated successfully' });
  } catch (error) {
    console.error('Error:', error);
    return res.status(500).json({ error: 'Database error' });
  }
});

app.delete('/api/shift-types/:id', async (req, res) => {
  try {
    const { id } = req.params;

    const connection = await mysql.createConnection(dbConfig);
    await connection.execute('UPDATE shift_types SET is_active = 0, updated_at = NOW() WHERE id = ?', [id]);
    await connection.end();

    return res.json({ message: 'Shift type deleted successfully' });
  } catch (error) {
    console.error('Error:', error);
    return res.status(500).json({ error: 'Database error' });
  }
});

// ============================================================================
// SHIFTS ENDPOINTS
// ============================================================================

app.get('/api/shifts', async (req, res) => {
  try {
    const connection = await mysql.createConnection(dbConfig);
    const [shifts] = await connection.execute(`
      SELECT s.*, st.name as shift_type_name, st.display_type, st.color
      FROM shifts s
      LEFT JOIN shift_types st ON s.shift_type_id = st.id
      WHERE s.is_active = 1
      ORDER BY s.name
    `);
    await connection.end();
    res.json(shifts);
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Database error' });
  }
});

app.post('/api/shifts', async (req, res) => {
  try {
    const { name, shift_type_id, starts_at, ends_at, days_on, days_off, shift_offset, ground_zero_date, is_active } = req.body;

    if (!name || !starts_at || !ends_at || !days_on || !days_off || !ground_zero_date) {
      return res.status(400).json({ error: 'Missing required shift data' });
    }

    const connection = await mysql.createConnection(dbConfig);
    const [result] = await connection.execute(
      'INSERT INTO shifts (name, shift_type_id, starts_at, ends_at, days_on, days_off, shift_offset, ground_zero_date, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [name, shift_type_id || null, starts_at, ends_at, days_on, days_off, shift_offset || 0, ground_zero_date, is_active ? 1 : 0]
    );
    await connection.end();

    return res.status(201).json({ id: (result as any).insertId, message: 'Shift created successfully' });
  } catch (error) {
    console.error('Error:', error);
    return res.status(500).json({ error: 'Database error' });
  }
});

app.put('/api/shifts/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { name, shift_type_id, starts_at, ends_at, days_on, days_off, shift_offset, ground_zero_date, is_active } = req.body;

    if (!name || !starts_at || !ends_at || !days_on || !days_off || !ground_zero_date) {
      return res.status(400).json({ error: 'Missing required shift data' });
    }

    const connection = await mysql.createConnection(dbConfig);
    await connection.execute(
      'UPDATE shifts SET name = ?, shift_type_id = ?, starts_at = ?, ends_at = ?, days_on = ?, days_off = ?, shift_offset = ?, ground_zero_date = ?, is_active = ?, updated_at = NOW() WHERE id = ?',
      [name, shift_type_id || null, starts_at, ends_at, days_on, days_off, shift_offset || 0, ground_zero_date, is_active ? 1 : 0, id]
    );
    await connection.end();

    return res.json({ message: 'Shift updated successfully' });
  } catch (error) {
    console.error('Error:', error);
    return res.status(500).json({ error: 'Database error' });
  }
});

app.delete('/api/shifts/:id', async (req, res) => {
  try {
    const { id } = req.params;

    const connection = await mysql.createConnection(dbConfig);
    await connection.execute('UPDATE shifts SET is_active = 0, updated_at = NOW() WHERE id = ?', [id]);
    await connection.end();

    return res.json({ message: 'Shift deleted successfully' });
  } catch (error) {
    console.error('Error:', error);
    return res.status(500).json({ error: 'Database error' });
  }
});

app.get('/api/assignments', async (req, res) => {
  try {
    const connection = await mysql.createConnection(dbConfig);
    const [assignments] = await connection.execute(`
      SELECT
        pa.*,
        p.name as porter_name,
        d.name as department_name,
        s.name as service_name
      FROM porter_assignments pa
      LEFT JOIN porters p ON pa.porter_id = p.id
      LEFT JOIN departments d ON pa.department_id = d.id
      LEFT JOIN services s ON pa.service_id = s.id
      WHERE pa.is_active = 1
      ORDER BY pa.start_date DESC
    `);
    await connection.end();
    res.json(assignments);
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Database error' });
  }
});

// ============================================================================
// SHIFT CALCULATION AND SCHEDULE ENDPOINTS
// ============================================================================

// Helper function to calculate if a shift is active on a given date
function calculateActiveShift(date: Date, shift: any): boolean {
  const groundZero = new Date(shift.ground_zero_date);
  const daysDiff = Math.floor((date.getTime() - groundZero.getTime()) / (1000 * 60 * 60 * 24));
  const adjustedDays = daysDiff + shift.shift_offset;
  const cycleLength = shift.days_on + shift.days_off;
  const cyclePosition = adjustedDays % cycleLength;
  return cyclePosition >= 0 && cyclePosition < shift.days_on;
}

// Helper function to calculate if a porter is active on their shift for a given date
function calculatePorterActiveShift(date: Date, porter: any, shift: any): boolean {
  const porterGroundZero = new Date(shift.ground_zero_date);
  porterGroundZero.setDate(porterGroundZero.getDate() + (porter.porter_offset || 0));

  const daysDiff = Math.floor((date.getTime() - porterGroundZero.getTime()) / (1000 * 60 * 60 * 24));
  const cycleLength = shift.days_on + shift.days_off;
  const cyclePosition = daysDiff % cycleLength;
  return cyclePosition >= 0 && cyclePosition < shift.days_on;
}

// Get active shifts for a specific date
app.get('/api/shifts/active/:date', async (req, res) => {
  try {
    const { date } = req.params;
    const targetDate = new Date(date);

    const connection = await mysql.createConnection(dbConfig);
    const [shifts] = await connection.execute('SELECT * FROM shifts WHERE is_active = 1');

    const activeShifts = (shifts as any[]).filter(shift => calculateActiveShift(targetDate, shift));

    await connection.end();
    res.json(activeShifts);
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Database error' });
  }
});

// Get complete schedule for a date (departments + active shifts + assigned porters)
app.get('/api/schedule/:date', async (req, res) => {
  try {
    const { date } = req.params;
    const targetDate = new Date(date);

    const connection = await mysql.createConnection(dbConfig);

    // Get departments and services
    const [departments] = await connection.execute('SELECT * FROM departments WHERE is_active = 1 ORDER BY name');
    const [services] = await connection.execute('SELECT * FROM services WHERE is_active = 1 ORDER BY name');

    // Get shifts and calculate which are active
    const [shifts] = await connection.execute(`
      SELECT s.*, st.name as shift_type_name, st.display_type, st.color
      FROM shifts s
      LEFT JOIN shift_types st ON s.shift_type_id = st.id
      WHERE s.is_active = 1
    `);
    const activeShifts = (shifts as any[]).filter(shift => calculateActiveShift(targetDate, shift));

    // Get porters with their assignments
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

    // Build active shifts with assigned porters
    const activeShiftsWithPorters = activeShifts.map(shift => {
      const assignedPorters = (porters as any[])
        .filter(porter => porter.shift_id === shift.id)
        .map(porter => {
          const isActiveToday = calculatePorterActiveShift(targetDate, porter, shift);
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

    await connection.end();

    res.json({
      date: date,
      departments,
      services,
      active_shifts: activeShiftsWithPorters
    });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Database error' });
  }
});

// Manual data freezing endpoint (for testing)
app.post('/api/admin/freeze-data', async (req, res) => {
  try {
    const { date } = req.body;
    await dataFreezingJob.runManually(date);
    res.json({
      message: `Data freezing completed for ${date || 'today'}`,
      success: true
    });
  } catch (error) {
    console.error('Manual data freezing failed:', error);
    res.status(500).json({
      error: 'Data freezing failed',
      message: error instanceof Error ? error.message : 'Unknown error'
    });
  }
});

// Get frozen schedule data
app.get('/api/schedule/frozen/:date', async (req, res) => {
  try {
    const { date } = req.params;

    const connection = await mysql.createConnection(dbConfig);
    const [frozen] = await connection.execute(
      'SELECT * FROM frozen_schedules WHERE date = ?',
      [date]
    );
    await connection.end();

    if ((frozen as any[]).length === 0) {
      return res.status(404).json({ error: 'No frozen data found for this date' });
    }

    const frozenData = (frozen as any[])[0];
    const scheduleData = typeof frozenData.schedule_data === 'string'
      ? JSON.parse(frozenData.schedule_data)
      : frozenData.schedule_data;

    return res.json({
      ...scheduleData,
      frozen_at: frozenData.frozen_at,
      is_frozen: true
    });
  } catch (error) {
    console.error('Error:', error);
    return res.status(500).json({ error: 'Database error' });
  }
});

// Start server
async function startServer() {
  try {
    // Test database connection
    const dbConnected = await testConnection();
    if (!dbConnected) {
      console.error('Failed to connect to database, exiting...');
      process.exit(1);
    }

    // Start HTTP server
    app.listen(PORT, () => {
      console.log(`🚀 Porter Tracking System API v2.0 started`);
      console.log(`📡 Server running on port ${PORT}`);
      console.log(`🏥 Health check: http://localhost:${PORT}/health`);
      console.log(`📊 Departments: http://localhost:${PORT}/api/departments`);
      console.log(`🔧 Services: http://localhost:${PORT}/api/services`);

      // Start the data freezing job scheduler
      dataFreezingJob.start();
    });
  } catch (error) {
    console.error('Failed to start server:', error);
    process.exit(1);
  }
}

startServer();
