import { Router, Request, Response, NextFunction } from 'express';
import { getConnection } from '../config/database';
import { CreatePorterRequest } from '../types';
import { createError } from '../middleware/errorHandler';

const router = Router();

// GET /api/porters - Get all porters with details
router.get('/', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const connection = getConnection();
    
    // Basic implementation - will expand with full details
    const [porters] = await connection.execute(`
      SELECT p.*, s.name as shift_name, d.name as department_name
      FROM porters p
      LEFT JOIN shifts s ON p.shift_id = s.id
      LEFT JOIN departments d ON p.regular_department_id = d.id
      ORDER BY p.name
    `);
    
    res.json(porters);
  } catch (error) {
    next(error);
  }
});

// GET /api/porters/:id - Get specific porter with full details
router.get('/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const connection = getConnection();
    
    const [porters] = await connection.execute(
      'SELECT * FROM porters WHERE id = ?',
      [id]
    );
    
    if ((porters as any[]).length === 0) {
      throw createError('Porter not found', 404);
    }
    
    res.json((porters as any[])[0]);
  } catch (error) {
    next(error);
  }
});

// POST /api/porters - Create new porter
router.post('/', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const porterData: CreatePorterRequest = req.body;
    
    if (!porterData.name || !porterData.contracted_hours_type) {
      throw createError('Name and contracted_hours_type are required', 400);
    }
    
    const connection = getConnection();
    
    // Basic implementation - will expand with full logic
    const [result] = await connection.execute(
      'INSERT INTO porters (name, porter_type, contracted_hours_type, shift_id, regular_department_id, is_floor_staff, weekly_hours) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [
        porterData.name,
        porterData.porter_type || 'PORTER',
        porterData.contracted_hours_type,
        porterData.shift_id || null,
        porterData.regular_department_id || null,
        porterData.is_floor_staff || false,
        porterData.weekly_hours || 37.5
      ]
    );
    
    const porterId = (result as any).insertId;
    
    const [newPorter] = await connection.execute(
      'SELECT * FROM porters WHERE id = ?',
      [porterId]
    );
    
    res.status(201).json((newPorter as any[])[0]);
  } catch (error) {
    next(error);
  }
});

// PUT /api/porters/:id - Update porter
router.put('/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    // Implementation placeholder
    res.json({ message: 'Porter update endpoint - to be implemented' });
  } catch (error) {
    next(error);
  }
});

// DELETE /api/porters/:id - Delete porter
router.delete('/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    // Implementation placeholder
    res.json({ message: 'Porter delete endpoint - to be implemented' });
  } catch (error) {
    next(error);
  }
});

export default router;
