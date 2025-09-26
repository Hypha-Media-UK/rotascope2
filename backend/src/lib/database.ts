// Database connection and query utilities with proper pooling
import mysql from 'mysql2/promise';
import logger from './logger.js';

// Database configuration
const dbConfig = {
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '3307'),
  user: process.env.DB_USER || 'rotascope_user',
  password: process.env.DB_PASSWORD || 'rotascope_password',
  database: process.env.DB_NAME || 'rotascope',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
  acquireTimeout: 60000,
  timeout: 60000,
  reconnect: true,
  charset: 'utf8mb4',
};

// Create connection pool
const pool = mysql.createPool(dbConfig);

// Test database connection
export async function testConnection(): Promise<boolean> {
  try {
    const connection = await pool.getConnection();
    await connection.ping();
    connection.release();
    logger.info('Database connection successful');
    return true;
  } catch (error) {
    logger.error('Database connection failed:', error);
    return false;
  }
}

// Execute query with proper error handling
export async function executeQuery<T = any>(
  query: string,
  params: any[] = []
): Promise<T[]> {
  try {
    logger.debug(`Executing query: ${query}`, { params });
    const [rows] = await pool.execute(query, params);
    return rows as T[];
  } catch (error) {
    logger.error('Database query failed:', { query, params, error });
    throw new DatabaseError('Query execution failed', error as Error);
  }
}

// Execute transaction with rollback support
export async function executeTransaction<T>(
  callback: (connection: mysql.PoolConnection) => Promise<T>
): Promise<T> {
  const connection = await pool.getConnection();
  
  try {
    await connection.beginTransaction();
    logger.debug('Transaction started');
    
    const result = await callback(connection);
    
    await connection.commit();
    logger.debug('Transaction committed');
    
    return result;
  } catch (error) {
    await connection.rollback();
    logger.error('Transaction rolled back:', error);
    throw error;
  } finally {
    connection.release();
  }
}

// Get single record
export async function findOne<T = any>(
  query: string,
  params: any[] = []
): Promise<T | null> {
  const results = await executeQuery<T>(query, params);
  return results.length > 0 ? results[0] : null;
}

// Get paginated results
export async function findPaginated<T = any>(
  baseQuery: string,
  countQuery: string,
  params: any[] = [],
  page: number = 1,
  limit: number = 20
): Promise<{ data: T[]; total: number; page: number; limit: number; totalPages: number }> {
  const offset = (page - 1) * limit;
  
  // Get total count
  const countResult = await findOne<{ count: number }>(countQuery, params);
  const total = countResult?.count || 0;
  
  // Get paginated data
  const paginatedQuery = `${baseQuery} LIMIT ? OFFSET ?`;
  const data = await executeQuery<T>(paginatedQuery, [...params, limit, offset]);
  
  return {
    data,
    total,
    page,
    limit,
    totalPages: Math.ceil(total / limit),
  };
}

// Insert record and return ID
export async function insertRecord(
  table: string,
  data: Record<string, any>
): Promise<number> {
  const fields = Object.keys(data);
  const values = Object.values(data);
  const placeholders = fields.map(() => '?').join(', ');
  
  const query = `INSERT INTO ${table} (${fields.join(', ')}) VALUES (${placeholders})`;
  
  try {
    const [result] = await pool.execute(query, values) as any;
    logger.info(`Record inserted into ${table}`, { id: result.insertId });
    return result.insertId;
  } catch (error) {
    logger.error(`Failed to insert record into ${table}:`, { data, error });
    throw new DatabaseError(`Insert failed for table ${table}`, error as Error);
  }
}

// Update record
export async function updateRecord(
  table: string,
  id: number,
  data: Record<string, any>
): Promise<boolean> {
  const fields = Object.keys(data);
  const values = Object.values(data);
  const setClause = fields.map(field => `${field} = ?`).join(', ');
  
  const query = `UPDATE ${table} SET ${setClause}, updated_at = NOW() WHERE id = ?`;
  
  try {
    const [result] = await pool.execute(query, [...values, id]) as any;
    const success = result.affectedRows > 0;
    
    if (success) {
      logger.info(`Record updated in ${table}`, { id });
    } else {
      logger.warn(`No record found to update in ${table}`, { id });
    }
    
    return success;
  } catch (error) {
    logger.error(`Failed to update record in ${table}:`, { id, data, error });
    throw new DatabaseError(`Update failed for table ${table}`, error as Error);
  }
}

// Soft delete record (set is_active = false)
export async function softDeleteRecord(table: string, id: number): Promise<boolean> {
  return updateRecord(table, id, { is_active: false });
}

// Hard delete record
export async function deleteRecord(table: string, id: number): Promise<boolean> {
  const query = `DELETE FROM ${table} WHERE id = ?`;
  
  try {
    const [result] = await pool.execute(query, [id]) as any;
    const success = result.affectedRows > 0;
    
    if (success) {
      logger.info(`Record deleted from ${table}`, { id });
    } else {
      logger.warn(`No record found to delete in ${table}`, { id });
    }
    
    return success;
  } catch (error) {
    logger.error(`Failed to delete record from ${table}:`, { id, error });
    throw new DatabaseError(`Delete failed for table ${table}`, error as Error);
  }
}

// Custom database error class
export class DatabaseError extends Error {
  public readonly originalError?: Error;
  
  constructor(message: string, originalError?: Error) {
    super(message);
    this.name = 'DatabaseError';
    this.originalError = originalError;
    
    // Maintain proper stack trace
    if (Error.captureStackTrace) {
      Error.captureStackTrace(this, DatabaseError);
    }
  }
}

// Graceful shutdown
export async function closePool(): Promise<void> {
  try {
    await pool.end();
    logger.info('Database pool closed');
  } catch (error) {
    logger.error('Error closing database pool:', error);
  }
}

// Export pool for advanced usage
export { pool };

export default {
  testConnection,
  executeQuery,
  executeTransaction,
  findOne,
  findPaginated,
  insertRecord,
  updateRecord,
  softDeleteRecord,
  deleteRecord,
  closePool,
};
