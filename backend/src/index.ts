// Porter Tracking System - Main Application Entry Point
import express from 'express';
import cors from 'cors';
import mysql from 'mysql2/promise';

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
  } catch (error) {
    console.error('Error:', error);
    return res.status(500).json({ error: 'Database error' });
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
      'UPDATE departments SET name = ?, is_24_7 = ?, porters_required_day = ?, porters_required_night = ?, updated_at = NOW() WHERE id = ?',
      [name, is_24_7 ? 1 : 0, porters_required_day, porters_required_night, id]
    );
    await connection.end();

    return res.json({ message: 'Department updated successfully' });
  } catch (error) {
    console.error('Error:', error);
    return res.status(500).json({ error: 'Database error' });
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

app.post('/api/porters', async (req, res) => {
  try {
    const { name, email, porter_type, contracted_hours_type, weekly_contracted_hours, is_active } = req.body;

    if (!name || !porter_type || !contracted_hours_type) {
      return res.status(400).json({ error: 'Missing required porter data' });
    }

    const connection = await mysql.createConnection(dbConfig);
    const [result] = await connection.execute(
      'INSERT INTO porters (name, email, porter_type, contracted_hours_type, weekly_contracted_hours, is_active) VALUES (?, ?, ?, ?, ?, ?)',
      [name, email || null, porter_type, contracted_hours_type, weekly_contracted_hours || 37.50, is_active ? 1 : 0]
    );
    await connection.end();

    return res.status(201).json({ id: (result as any).insertId, message: 'Porter created successfully' });
  } catch (error) {
    console.error('Error:', error);
    return res.status(500).json({ error: 'Database error' });
  }
});

app.put('/api/porters/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { name, email, porter_type, contracted_hours_type, weekly_contracted_hours, is_active } = req.body;

    if (!name || !porter_type || !contracted_hours_type) {
      return res.status(400).json({ error: 'Missing required porter data' });
    }

    const connection = await mysql.createConnection(dbConfig);
    await connection.execute(
      'UPDATE porters SET name = ?, email = ?, porter_type = ?, contracted_hours_type = ?, weekly_contracted_hours = ?, is_active = ?, updated_at = NOW() WHERE id = ?',
      [name, email || null, porter_type, contracted_hours_type, weekly_contracted_hours || 37.50, is_active ? 1 : 0, id]
    );
    await connection.end();

    return res.json({ message: 'Porter updated successfully' });
  } catch (error) {
    console.error('Error:', error);
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

app.get('/api/shifts', async (req, res) => {
  try {
    const connection = await mysql.createConnection(dbConfig);
    const [shifts] = await connection.execute('SELECT * FROM shifts WHERE is_active = 1 ORDER BY name');
    await connection.end();
    res.json(shifts);
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({ error: 'Database error' });
  }
});

app.post('/api/shifts', async (req, res) => {
  try {
    const { name, shift_type, shift_identifier, starts_at, ends_at, days_on, days_off, shift_offset, ground_zero_date, is_active } = req.body;

    if (!name || !shift_type || !shift_identifier || !starts_at || !ends_at || !days_on || !days_off || !ground_zero_date) {
      return res.status(400).json({ error: 'Missing required shift data' });
    }

    const connection = await mysql.createConnection(dbConfig);
    const [result] = await connection.execute(
      'INSERT INTO shifts (name, shift_type, shift_identifier, starts_at, ends_at, days_on, days_off, shift_offset, ground_zero_date, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [name, shift_type, shift_identifier, starts_at, ends_at, days_on, days_off, shift_offset || 0, ground_zero_date, is_active ? 1 : 0]
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
    const { name, shift_type, shift_identifier, starts_at, ends_at, days_on, days_off, shift_offset, ground_zero_date, is_active } = req.body;

    if (!name || !shift_type || !shift_identifier || !starts_at || !ends_at || !days_on || !days_off || !ground_zero_date) {
      return res.status(400).json({ error: 'Missing required shift data' });
    }

    const connection = await mysql.createConnection(dbConfig);
    await connection.execute(
      'UPDATE shifts SET name = ?, shift_type = ?, shift_identifier = ?, starts_at = ?, ends_at = ?, days_on = ?, days_off = ?, shift_offset = ?, ground_zero_date = ?, is_active = ?, updated_at = NOW() WHERE id = ?',
      [name, shift_type, shift_identifier, starts_at, ends_at, days_on, days_off, shift_offset || 0, ground_zero_date, is_active ? 1 : 0, id]
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
    });
  } catch (error) {
    console.error('Failed to start server:', error);
    process.exit(1);
  }
}

startServer();
