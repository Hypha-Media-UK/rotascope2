// Standardized API response utilities
import { Response } from 'express';
import logger from './logger.js';

// Standard API response interface
export interface ApiResponse<T = any> {
  success: boolean;
  data?: T;
  message?: string;
  error?: {
    code: string;
    message: string;
    details?: any;
  };
  meta?: {
    page?: number;
    limit?: number;
    total?: number;
    totalPages?: number;
    timestamp: string;
    requestId?: string;
  };
}

// Success response
export function sendSuccess<T>(
  res: Response,
  data?: T,
  message?: string,
  statusCode: number = 200,
  meta?: Partial<ApiResponse['meta']>
): void {
  const response: ApiResponse<T> = {
    success: true,
    data,
    message,
    meta: {
      timestamp: new Date().toISOString(),
      ...meta,
    },
  };

  logger.info(`API Success: ${res.req.method} ${res.req.path}`, {
    statusCode,
    message,
    dataType: data ? typeof data : 'none',
  });

  res.status(statusCode).json(response);
}

// Error response
export function sendError(
  res: Response,
  error: {
    code: string;
    message: string;
    details?: any;
  },
  statusCode: number = 500,
  requestId?: string
): void {
  const response: ApiResponse = {
    success: false,
    error,
    meta: {
      timestamp: new Date().toISOString(),
      requestId,
    },
  };

  logger.error(`API Error: ${res.req.method} ${res.req.path}`, {
    statusCode,
    error: error.code,
    message: error.message,
    details: error.details,
  });

  res.status(statusCode).json(response);
}

// Validation error response
export function sendValidationError(
  res: Response,
  validationErrors: any,
  requestId?: string
): void {
  sendError(
    res,
    {
      code: 'VALIDATION_ERROR',
      message: 'Request validation failed',
      details: validationErrors,
    },
    400,
    requestId
  );
}

// Not found error response
export function sendNotFound(
  res: Response,
  resource: string = 'Resource',
  requestId?: string
): void {
  sendError(
    res,
    {
      code: 'NOT_FOUND',
      message: `${resource} not found`,
    },
    404,
    requestId
  );
}

// Unauthorized error response
export function sendUnauthorized(
  res: Response,
  message: string = 'Unauthorized access',
  requestId?: string
): void {
  sendError(
    res,
    {
      code: 'UNAUTHORIZED',
      message,
    },
    401,
    requestId
  );
}

// Forbidden error response
export function sendForbidden(
  res: Response,
  message: string = 'Access forbidden',
  requestId?: string
): void {
  sendError(
    res,
    {
      code: 'FORBIDDEN',
      message,
    },
    403,
    requestId
  );
}

// Conflict error response
export function sendConflict(
  res: Response,
  message: string = 'Resource conflict',
  details?: any,
  requestId?: string
): void {
  sendError(
    res,
    {
      code: 'CONFLICT',
      message,
      details,
    },
    409,
    requestId
  );
}

// Internal server error response
export function sendInternalError(
  res: Response,
  message: string = 'Internal server error',
  details?: any,
  requestId?: string
): void {
  sendError(
    res,
    {
      code: 'INTERNAL_ERROR',
      message,
      details: process.env.NODE_ENV === 'development' ? details : undefined,
    },
    500,
    requestId
  );
}

// Paginated success response
export function sendPaginatedSuccess<T>(
  res: Response,
  data: T[],
  pagination: {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
  },
  message?: string,
  requestId?: string
): void {
  sendSuccess(
    res,
    data,
    message,
    200,
    {
      ...pagination,
      requestId,
    }
  );
}

// Created response
export function sendCreated<T>(
  res: Response,
  data: T,
  message?: string,
  requestId?: string
): void {
  sendSuccess(res, data, message || 'Resource created successfully', 201, { requestId });
}

// Updated response
export function sendUpdated<T>(
  res: Response,
  data?: T,
  message?: string,
  requestId?: string
): void {
  sendSuccess(res, data, message || 'Resource updated successfully', 200, { requestId });
}

// Deleted response
export function sendDeleted(
  res: Response,
  message?: string,
  requestId?: string
): void {
  sendSuccess(res, undefined, message || 'Resource deleted successfully', 200, { requestId });
}

// No content response
export function sendNoContent(res: Response): void {
  res.status(204).send();
}

export default {
  sendSuccess,
  sendError,
  sendValidationError,
  sendNotFound,
  sendUnauthorized,
  sendForbidden,
  sendConflict,
  sendInternalError,
  sendPaginatedSuccess,
  sendCreated,
  sendUpdated,
  sendDeleted,
  sendNoContent,
};
