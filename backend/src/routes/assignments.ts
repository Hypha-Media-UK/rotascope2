import { Router, Request, Response, NextFunction } from 'express';
import { getConnection } from '../config/database';
import { CreateAssignmentRequest } from '../types';
import { createError } from '../middleware/errorHandler';

const router = Router();

// GET /api/assignments - Get all assignments
router.get('/', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const connection = getConnection();
    
    const [assignments] = await connection.execute(`
      SELECT 
        pa.*,
        p.name as porter_name,
        d.name as department_name
      FROM porter_assignments pa
      JOIN porters p ON pa.porter_id = p.id
      JOIN departments d ON pa.department_id = d.id
      ORDER BY pa.start_date DESC
    `);
    
    res.json(assignments);
  } catch (error) {
    next(error);
  }
});

// GET /api/assignments/current - Get current active assignments
router.get('/current', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const connection = getConnection();
    
    const [assignments] = await connection.execute(`
      SELECT 
        pa.*,
        p.name as porter_name,
        d.name as department_name
      FROM porter_assignments pa
      JOIN porters p ON pa.porter_id = p.id
      JOIN departments d ON pa.department_id = d.id
      WHERE pa.start_date <= CURDATE() 
        AND (pa.end_date IS NULL OR pa.end_date >= CURDATE())
      ORDER BY d.name, p.name
    `);
    
    res.json(assignments);
  } catch (error) {
    next(error);
  }
});

// POST /api/assignments - Create new assignment
router.post('/', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const assignmentData: CreateAssignmentRequest = req.body;
    
    if (!assignmentData.porter_id || !assignmentData.department_id || !assignmentData.start_date) {
      throw createError('porter_id, department_id, and start_date are required', 400);
    }
    
    const connection = getConnection();
    
    // Check for overlapping assignments for the same porter
    let overlapQuery = `
      SELECT id FROM porter_assignments 
      WHERE porter_id = ? 
        AND start_date <= ? 
        AND (end_date IS NULL OR end_date >= ?)
    `;
    
    const overlapParams = [
      assignmentData.porter_id,
      assignmentData.end_date || '9999-12-31',
      assignmentData.start_date
    ];
    
    const [overlapping] = await connection.execute(overlapQuery, overlapParams);
    
    if ((overlapping as any[]).length > 0) {
      throw createError('Porter already has an overlapping assignment for this period', 400);
    }
    
    const [result] = await connection.execute(
      'INSERT INTO porter_assignments (porter_id, department_id, start_date, end_date, assignment_type, notes) VALUES (?, ?, ?, ?, ?, ?)',
      [
        assignmentData.porter_id,
        assignmentData.department_id,
        assignmentData.start_date,
        assignmentData.end_date || null,
        assignmentData.assignment_type || 'PERMANENT',
        assignmentData.notes || null
      ]
    );
    
    const assignmentId = (result as any).insertId;
    
    const [newAssignment] = await connection.execute(
      `SELECT 
        pa.*,
        p.name as porter_name,
        d.name as department_name
      FROM porter_assignments pa
      JOIN porters p ON pa.porter_id = p.id
      JOIN departments d ON pa.department_id = d.id
      WHERE pa.id = ?`,
      [assignmentId]
    );
    
    res.status(201).json((newAssignment as any[])[0]);
  } catch (error) {
    next(error);
  }
});

// PUT /api/assignments/:id - Update assignment
router.put('/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    // Implementation placeholder
    res.json({ message: 'Assignment update endpoint - to be implemented' });
  } catch (error) {
    next(error);
  }
});

// DELETE /api/assignments/:id - Delete assignment
router.delete('/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const connection = getConnection();
    
    const [result] = await connection.execute(
      'DELETE FROM porter_assignments WHERE id = ?',
      [id]
    );
    
    if ((result as any).affectedRows === 0) {
      throw createError('Assignment not found', 404);
    }
    
    res.status(204).send();
  } catch (error) {
    next(error);
  }
});

export default router;
