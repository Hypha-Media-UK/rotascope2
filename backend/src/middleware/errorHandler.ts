// Global error handling middleware
import { Request, Response, NextFunction } from 'express';
import { DatabaseError } from '../lib/database.js';
import { sendInternalError, sendError } from '../lib/response.js';
import logger from '../lib/logger.js';

// Custom application error class
export class AppError extends Error {
  public readonly statusCode: number;
  public readonly code: string;
  public readonly isOperational: boolean;
  public readonly details?: any;

  constructor(
    message: string,
    statusCode: number = 500,
    code: string = 'INTERNAL_ERROR',
    isOperational: boolean = true,
    details?: any
  ) {
    super(message);
    this.name = 'AppError';
    this.statusCode = statusCode;
    this.code = code;
    this.isOperational = isOperational;
    this.details = details;

    // Maintain proper stack trace
    if (Error.captureStackTrace) {
      Error.captureStackTrace(this, AppError);
    }
  }
}

// Specific error classes
export class ValidationError extends AppError {
  constructor(message: string, details?: any) {
    super(message, 400, 'VALIDATION_ERROR', true, details);
  }
}

export class NotFoundError extends AppError {
  constructor(resource: string = 'Resource') {
    super(`${resource} not found`, 404, 'NOT_FOUND', true);
  }
}

export class ConflictError extends AppError {
  constructor(message: string, details?: any) {
    super(message, 409, 'CONFLICT', true, details);
  }
}

export class UnauthorizedError extends AppError {
  constructor(message: string = 'Unauthorized access') {
    super(message, 401, 'UNAUTHORIZED', true);
  }
}

export class ForbiddenError extends AppError {
  constructor(message: string = 'Access forbidden') {
    super(message, 403, 'FORBIDDEN', true);
  }
}

// Error handler middleware
export function errorHandler(
  error: Error,
  req: Request,
  res: Response,
  next: NextFunction
): void {
  const requestId = req.headers['x-request-id'] as string;

  // Log the error
  logger.error('Unhandled error:', {
    error: error.message,
    stack: error.stack,
    url: req.url,
    method: req.method,
    requestId,
  });

  // Handle known error types
  if (error instanceof AppError) {
    sendError(
      res,
      {
        code: error.code,
        message: error.message,
        details: error.details,
      },
      error.statusCode,
      requestId
    );
    return;
  }

  // Handle database errors
  if (error instanceof DatabaseError) {
    sendError(
      res,
      {
        code: 'DATABASE_ERROR',
        message: 'Database operation failed',
        details: process.env.NODE_ENV === 'development' ? error.originalError?.message : undefined,
      },
      500,
      requestId
    );
    return;
  }

  // Handle MySQL errors
  if (error.name === 'Error' && 'code' in error) {
    const mysqlError = error as any;

    switch (mysqlError.code) {
      case 'ER_DUP_ENTRY':
        sendError(
          res,
          {
            code: 'DUPLICATE_ENTRY',
            message: 'Duplicate entry detected',
            details: process.env.NODE_ENV === 'development' ? mysqlError.message : undefined,
          },
          409,
          requestId
        );
        return;

      case 'ER_NO_REFERENCED_ROW_2':
        sendError(
          res,
          {
            code: 'FOREIGN_KEY_CONSTRAINT',
            message: 'Referenced record does not exist',
            details: process.env.NODE_ENV === 'development' ? mysqlError.message : undefined,
          },
          400,
          requestId
        );
        return;

      case 'ER_ROW_IS_REFERENCED_2':
        sendError(
          res,
          {
            code: 'FOREIGN_KEY_CONSTRAINT',
            message: 'Cannot delete record that is referenced by other records',
            details: process.env.NODE_ENV === 'development' ? mysqlError.message : undefined,
          },
          409,
          requestId
        );
        return;
    }
  }

  // Handle unexpected errors
  sendInternalError(
    res,
    'An unexpected error occurred',
    process.env.NODE_ENV === 'development' ? error.stack : undefined,
    requestId
  );
}

// 404 handler for unmatched routes
export function notFoundHandler(req: Request, res: Response, next: NextFunction): void {
  const requestId = req.headers['x-request-id'] as string;

  logger.warn(`Route not found: ${req.method} ${req.path}`, { requestId });

  sendError(
    res,
    {
      code: 'ROUTE_NOT_FOUND',
      message: `Route ${req.method} ${req.path} not found`,
    },
    404,
    requestId
  );
}

// Async error wrapper
export function asyncHandler<T extends Request, U extends Response>(
  fn: (req: T, res: U, next: NextFunction) => Promise<any>
) {
  return (req: T, res: U, next: NextFunction) => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
}

export default {
  errorHandler,
  notFoundHandler,
  asyncHandler,
  AppError,
  ValidationError,
  NotFoundError,
  ConflictError,
  UnauthorizedError,
  ForbiddenError,
};
