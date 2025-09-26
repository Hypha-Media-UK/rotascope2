import { Router, Request, Response, NextFunction } from 'express';
import { getConnection } from '../config/database';
import { CreateShiftRequest } from '../types';
import { createError } from '../middleware/errorHandler';

const router = Router();

// GET /api/shifts - Get all shifts
router.get('/', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const connection = getConnection();
    
    const [shifts] = await connection.execute(`
      SELECT * FROM shifts ORDER BY shift_type, shift_ident
    `);
    
    res.json(shifts);
  } catch (error) {
    next(error);
  }
});

// GET /api/shifts/:id - Get specific shift
router.get('/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const connection = getConnection();
    
    const [shifts] = await connection.execute(
      'SELECT * FROM shifts WHERE id = ?',
      [id]
    );
    
    if ((shifts as any[]).length === 0) {
      throw createError('Shift not found', 404);
    }
    
    res.json((shifts as any[])[0]);
  } catch (error) {
    next(error);
  }
});

// POST /api/shifts - Create new shift
router.post('/', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const shiftData: CreateShiftRequest = req.body;
    
    if (!shiftData.name || !shiftData.shift_type || !shiftData.shift_ident) {
      throw createError('Name, shift_type, and shift_ident are required', 400);
    }
    
    const connection = getConnection();
    
    // Check for duplicate shift_type + shift_ident combination
    const [existing] = await connection.execute(
      'SELECT id FROM shifts WHERE shift_type = ? AND shift_ident = ?',
      [shiftData.shift_type, shiftData.shift_ident]
    );
    
    if ((existing as any[]).length > 0) {
      throw createError('Shift with this type and identifier already exists', 400);
    }
    
    const [result] = await connection.execute(
      'INSERT INTO shifts (name, shift_type, shift_ident, starts_at, ends_at, days_on, days_off, shift_offset, ground_zero) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [
        shiftData.name,
        shiftData.shift_type,
        shiftData.shift_ident,
        shiftData.starts_at,
        shiftData.ends_at,
        shiftData.days_on || 1,
        shiftData.days_off || 1,
        shiftData.shift_offset || 0,
        shiftData.ground_zero
      ]
    );
    
    const shiftId = (result as any).insertId;
    
    const [newShift] = await connection.execute(
      'SELECT * FROM shifts WHERE id = ?',
      [shiftId]
    );
    
    res.status(201).json((newShift as any[])[0]);
  } catch (error) {
    next(error);
  }
});

// PUT /api/shifts/:id - Update shift
router.put('/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    // Implementation placeholder
    res.json({ message: 'Shift update endpoint - to be implemented' });
  } catch (error) {
    next(error);
  }
});

// DELETE /api/shifts/:id - Delete shift
router.delete('/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    // Implementation placeholder
    res.json({ message: 'Shift delete endpoint - to be implemented' });
  } catch (error) {
    next(error);
  }
});

export default router;
