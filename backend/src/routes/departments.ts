import { Router, Request, Response, NextFunction } from 'express';
import { getConnection } from '../config/database';
import { CreateDepartmentRequest, DepartmentWithHours } from '../types';
import { createError } from '../middleware/errorHandler';

const router = Router();

// GET /api/departments - Get all departments with their hours
router.get('/', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const connection = getConnection();
    
    // Get all departments
    const [departments] = await connection.execute(`
      SELECT * FROM departments ORDER BY name
    `);
    
    // Get all department hours
    const [hours] = await connection.execute(`
      SELECT * FROM department_hours ORDER BY department_id, day_of_week
    `);
    
    // Combine departments with their hours
    const departmentsWithHours = (departments as any[]).map(dept => ({
      ...dept,
      hours: (hours as any[]).filter(h => h.department_id === dept.id)
    }));
    
    res.json(departmentsWithHours);
  } catch (error) {
    next(error);
  }
});

// GET /api/departments/:id - Get specific department with hours
router.get('/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const connection = getConnection();
    
    // Get department
    const [departments] = await connection.execute(
      'SELECT * FROM departments WHERE id = ?',
      [id]
    );
    
    if ((departments as any[]).length === 0) {
      throw createError('Department not found', 404);
    }
    
    const department = (departments as any[])[0];
    
    // Get department hours
    const [hours] = await connection.execute(
      'SELECT * FROM department_hours WHERE department_id = ? ORDER BY day_of_week',
      [id]
    );
    
    const departmentWithHours: DepartmentWithHours = {
      ...department,
      hours: hours as any[]
    };
    
    res.json(departmentWithHours);
  } catch (error) {
    next(error);
  }
});

// POST /api/departments - Create new department
router.post('/', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { name, is_24_7, porters_required, hours }: CreateDepartmentRequest = req.body;
    
    if (!name || typeof porters_required !== 'number') {
      throw createError('Name and porters_required are required', 400);
    }
    
    const connection = getConnection();
    
    // Start transaction
    await connection.beginTransaction();
    
    try {
      // Insert department
      const [result] = await connection.execute(
        'INSERT INTO departments (name, is_24_7, porters_required) VALUES (?, ?, ?)',
        [name, is_24_7 || false, porters_required]
      );
      
      const departmentId = (result as any).insertId;
      
      // Insert department hours if not 24/7 and hours provided
      if (!is_24_7 && hours && hours.length > 0) {
        for (const hour of hours) {
          await connection.execute(
            'INSERT INTO department_hours (department_id, day_of_week, opens_at, closes_at, porters_required) VALUES (?, ?, ?, ?, ?)',
            [departmentId, hour.day_of_week, hour.opens_at, hour.closes_at, hour.porters_required]
          );
        }
      }
      
      await connection.commit();
      
      // Return created department with hours
      const [newDepartment] = await connection.execute(
        'SELECT * FROM departments WHERE id = ?',
        [departmentId]
      );
      
      const [newHours] = await connection.execute(
        'SELECT * FROM department_hours WHERE department_id = ? ORDER BY day_of_week',
        [departmentId]
      );
      
      const departmentWithHours: DepartmentWithHours = {
        ...(newDepartment as any[])[0],
        hours: newHours as any[]
      };
      
      res.status(201).json(departmentWithHours);
    } catch (error) {
      await connection.rollback();
      throw error;
    }
  } catch (error) {
    next(error);
  }
});

// PUT /api/departments/:id - Update department
router.put('/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const { name, is_24_7, porters_required, hours }: CreateDepartmentRequest = req.body;
    
    const connection = getConnection();
    
    // Check if department exists
    const [existing] = await connection.execute(
      'SELECT id FROM departments WHERE id = ?',
      [id]
    );
    
    if ((existing as any[]).length === 0) {
      throw createError('Department not found', 404);
    }
    
    // Start transaction
    await connection.beginTransaction();
    
    try {
      // Update department
      await connection.execute(
        'UPDATE departments SET name = ?, is_24_7 = ?, porters_required = ? WHERE id = ?',
        [name, is_24_7 || false, porters_required, id]
      );
      
      // Delete existing hours
      await connection.execute(
        'DELETE FROM department_hours WHERE department_id = ?',
        [id]
      );
      
      // Insert new hours if not 24/7 and hours provided
      if (!is_24_7 && hours && hours.length > 0) {
        for (const hour of hours) {
          await connection.execute(
            'INSERT INTO department_hours (department_id, day_of_week, opens_at, closes_at, porters_required) VALUES (?, ?, ?, ?, ?)',
            [id, hour.day_of_week, hour.opens_at, hour.closes_at, hour.porters_required]
          );
        }
      }
      
      await connection.commit();
      
      // Return updated department with hours
      const [updatedDepartment] = await connection.execute(
        'SELECT * FROM departments WHERE id = ?',
        [id]
      );
      
      const [updatedHours] = await connection.execute(
        'SELECT * FROM department_hours WHERE department_id = ? ORDER BY day_of_week',
        [id]
      );
      
      const departmentWithHours: DepartmentWithHours = {
        ...(updatedDepartment as any[])[0],
        hours: updatedHours as any[]
      };
      
      res.json(departmentWithHours);
    } catch (error) {
      await connection.rollback();
      throw error;
    }
  } catch (error) {
    next(error);
  }
});

// DELETE /api/departments/:id - Delete department
router.delete('/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const connection = getConnection();
    
    // Check if department exists
    const [existing] = await connection.execute(
      'SELECT id FROM departments WHERE id = ?',
      [id]
    );
    
    if ((existing as any[]).length === 0) {
      throw createError('Department not found', 404);
    }
    
    // Check if department has active assignments
    const [assignments] = await connection.execute(
      'SELECT COUNT(*) as count FROM porter_assignments WHERE department_id = ? AND (end_date IS NULL OR end_date >= CURDATE())',
      [id]
    );
    
    if ((assignments as any[])[0].count > 0) {
      throw createError('Cannot delete department with active porter assignments', 400);
    }
    
    // Delete department (cascade will handle hours)
    await connection.execute(
      'DELETE FROM departments WHERE id = ?',
      [id]
    );
    
    res.status(204).send();
  } catch (error) {
    next(error);
  }
});

export default router;
