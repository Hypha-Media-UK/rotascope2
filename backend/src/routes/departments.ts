// Departments API routes with proper validation and error handling
import express from 'express';
import { executeQuery, findOne, insertRecord, updateRecord, softDeleteRecord, executeTransaction, findPaginated } from '../lib/database.js';
import { sendSuccess, sendCreated, sendUpdated, sendDeleted, sendNotFound, sendPaginatedSuccess } from '../lib/response.js';
import { validateBody, validateQuery, validateIdParam } from '../middleware/validation.js';
import { asyncHandler, NotFoundError } from '../middleware/errorHandler.js';
import {
  CreateDepartmentSchema,
  UpdateDepartmentSchema,
  PaginationSchema,
  Department,
  DepartmentHours
} from '../lib/validation.js';
import logger from '../lib/logger.js';

const router = express.Router();

// Get all departments with pagination and filtering
router.get('/',
  validateQuery(PaginationSchema),
  asyncHandler(async (req, res) => {
    const { page, limit, sort = 'name', order } = req.query as any;
    const requestId = req.headers['x-request-id'] as string;

    logger.info('Fetching departments', { page, limit, sort, order, requestId });

    // Build query with optional sorting
    const validSortFields = ['name', 'code', 'created_at', 'updated_at'];
    const sortField = validSortFields.includes(sort) ? sort : 'name';
    const sortOrder = order === 'desc' ? 'DESC' : 'ASC';

    const baseQuery = `
      SELECT d.*,
             GROUP_CONCAT(
               CONCAT(dh.day_of_week, ':', dh.opens_at, '-', dh.closes_at, ':', dh.porters_required)
               ORDER BY dh.day_of_week
               SEPARATOR ';'
             ) as hours
      FROM departments d
      LEFT JOIN department_hours dh ON d.id = dh.department_id AND dh.is_active = 1
      WHERE d.is_active = 1
      GROUP BY d.id
      ORDER BY d.${sortField} ${sortOrder}
    `;

    const countQuery = `
      SELECT COUNT(*) as count
      FROM departments d
      WHERE d.is_active = 1
    `;

    const result = await findPaginated<Department & { hours: string }>(
      baseQuery,
      countQuery,
      [],
      page,
      limit
    );

    // Parse hours data
    const departmentsWithHours = result.data.map(dept => ({
      ...dept,
      hours: dept.hours ? dept.hours.split(';').map(h => {
        const [day, time, porters] = h.split(':');
        const [opens_at, closes_at] = time.split('-');
        return {
          day_of_week: parseInt(day),
          opens_at,
          closes_at,
          porters_required: parseInt(porters)
        };
      }) : []
    }));

    sendPaginatedSuccess(
      res,
      departmentsWithHours,
      {
        page: result.page,
        limit: result.limit,
        total: result.total,
        totalPages: result.totalPages
      },
      'Departments retrieved successfully',
      requestId
    );
  })
);

export default router;