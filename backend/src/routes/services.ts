import { Router, Request, Response, NextFunction } from 'express';
import { getConnection } from '../config/database';
import { createError } from '../middleware/errorHandler';

const router = Router();

// GET /api/services - Get all services with their hours
router.get('/', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const connection = getConnection();
    
    // Get all services
    const [services] = await connection.execute(`
      SELECT * FROM services ORDER BY name
    `);
    
    // Get all service hours
    const [hours] = await connection.execute(`
      SELECT * FROM service_hours ORDER BY service_id, day_of_week
    `);
    
    // Combine services with their hours
    const servicesWithHours = (services as any[]).map(service => ({
      ...service,
      hours: (hours as any[]).filter(h => h.service_id === service.id)
    }));
    
    res.json(servicesWithHours);
  } catch (error) {
    next(error);
  }
});

// GET /api/services/:id - Get specific service with hours
router.get('/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { id } = req.params;
    const connection = getConnection();
    
    // Get service
    const [services] = await connection.execute(
      'SELECT * FROM services WHERE id = ?',
      [id]
    );
    
    if ((services as any[]).length === 0) {
      throw createError('Service not found', 404);
    }
    
    const service = (services as any[])[0];
    
    // Get service hours
    const [hours] = await connection.execute(
      'SELECT * FROM service_hours WHERE service_id = ? ORDER BY day_of_week',
      [id]
    );
    
    const serviceWithHours = {
      ...service,
      hours: hours as any[]
    };
    
    res.json(serviceWithHours);
  } catch (error) {
    next(error);
  }
});

export default router;
