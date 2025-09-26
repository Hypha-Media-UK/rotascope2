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
