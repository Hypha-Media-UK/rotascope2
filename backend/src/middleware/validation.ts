// Validation middleware using Zod schemas
import { Request, Response, NextFunction } from 'express';
import { ZodSchema, ZodError } from 'zod';
import { sendValidationError } from '../lib/response.js';
import logger from '../lib/logger.js';

// Validation target types
type ValidationTarget = 'body' | 'query' | 'params';

// Validation middleware factory
export function validate(
  schema: ZodSchema,
  target: ValidationTarget = 'body'
) {
  return (req: Request, res: Response, next: NextFunction) => {
    try {
      const dataToValidate = req[target];
      
      logger.debug(`Validating ${target}:`, dataToValidate);
      
      // Parse and validate the data
      const validatedData = schema.parse(dataToValidate);
      
      // Replace the original data with validated data
      (req as any)[target] = validatedData;
      
      logger.debug(`Validation successful for ${target}`);
      next();
    } catch (error) {
      if (error instanceof ZodError) {
        logger.warn(`Validation failed for ${target}:`, {
          errors: error.errors,
          data: req[target],
        });
        
        // Format Zod errors for API response
        const formattedErrors = error.errors.map(err => ({
          field: err.path.join('.'),
          message: err.message,
          code: err.code,
          received: err.received,
        }));
        
        sendValidationError(res, formattedErrors, req.headers['x-request-id'] as string);
      } else {
        logger.error(`Unexpected validation error for ${target}:`, error);
        sendValidationError(
          res,
          [{ field: 'unknown', message: 'Validation failed', code: 'unknown' }],
          req.headers['x-request-id'] as string
        );
      }
    }
  };
}

// Validate request body
export function validateBody(schema: ZodSchema) {
  return validate(schema, 'body');
}

// Validate query parameters
export function validateQuery(schema: ZodSchema) {
  return validate(schema, 'query');
}

// Validate route parameters
export function validateParams(schema: ZodSchema) {
  return validate(schema, 'params');
}

// Common parameter schemas
import { z } from 'zod';

export const IdParamSchema = z.object({
  id: z.coerce.number().int().positive(),
});

export const OptionalIdParamSchema = z.object({
  id: z.coerce.number().int().positive().optional(),
});

// Validate ID parameter
export const validateIdParam = validateParams(IdParamSchema);

export default {
  validate,
  validateBody,
  validateQuery,
  validateParams,
  validateIdParam,
};
