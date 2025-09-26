import mysql from 'mysql2/promise';

let connection: mysql.Connection;

export async function connectDatabase(): Promise<mysql.Connection> {
  try {
    connection = await mysql.createConnection({
      host: process.env.DB_HOST || 'localhost',
      port: parseInt(process.env.DB_PORT || '3306'),
      user: process.env.DB_USER || 'rotascope_user',
      password: process.env.DB_PASSWORD || 'rotascope_password',
      database: process.env.DB_NAME || 'rotascope',
      timezone: '+00:00', // Use UTC
      dateStrings: false,
      supportBigNumbers: true,
      bigNumberStrings: false
    });

    // Test the connection
    await connection.ping();
    
    return connection;
  } catch (error) {
    console.error('Database connection failed:', error);
    throw error;
  }
}

export function getConnection(): mysql.Connection {
  if (!connection) {
    throw new Error('Database not connected. Call connectDatabase() first.');
  }
  return connection;
}

export async function closeConnection(): Promise<void> {
  if (connection) {
    await connection.end();
  }
}
