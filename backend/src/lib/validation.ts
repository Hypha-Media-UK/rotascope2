// Validation schemas using Zod for runtime type safety
import { z } from 'zod';

// ============================================================================
// CORE ENTITY SCHEMAS
// ============================================================================

export const DepartmentSchema = z.object({
  id: z.number().int().positive(),
  name: z.string().min(2).max(100),
  code: z.string().min(2).max(20),
  is_24_7: z.boolean(),
  porters_required_day: z.number().int().positive(),
  porters_required_night: z.number().int().positive(),
  is_active: z.boolean(),
  created_at: z.string().datetime(),
  updated_at: z.string().datetime(),
});

export const ServiceSchema = z.object({
  id: z.number().int().positive(),
  name: z.string().min(2).max(100),
  code: z.string().min(2).max(20),
  is_24_7: z.boolean(),
  porters_required_day: z.number().int().positive(),
  porters_required_night: z.number().int().positive(),
  is_active: z.boolean(),
  created_at: z.string().datetime(),
  updated_at: z.string().datetime(),
});

export const DepartmentHoursSchema = z.object({
  id: z.number().int().positive(),
  department_id: z.number().int().positive(),
  day_of_week: z.number().int().min(1).max(7), // 1=Monday, 7=Sunday
  opens_at: z.string().regex(/^([0-1]?[0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$/),
  closes_at: z.string().regex(/^([0-1]?[0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$/),
  porters_required: z.number().int().positive(),
  is_active: z.boolean(),
  created_at: z.string().datetime(),
  updated_at: z.string().datetime(),
});

export const ServiceHoursSchema = z.object({
  id: z.number().int().positive(),
  service_id: z.number().int().positive(),
  day_of_week: z.number().int().min(1).max(7),
  opens_at: z.string().regex(/^([0-1]?[0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$/),
  closes_at: z.string().regex(/^([0-1]?[0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$/),
  porters_required: z.number().int().positive(),
  is_active: z.boolean(),
  created_at: z.string().datetime(),
  updated_at: z.string().datetime(),
});

export const ShiftSchema = z.object({
  id: z.number().int().positive(),
  name: z.string().min(3).max(100),
  shift_type: z.enum(['DAY', 'NIGHT']),
  shift_identifier: z.enum(['A', 'B', 'C', 'D']),
  starts_at: z.string().regex(/^([0-1]?[0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$/),
  ends_at: z.string().regex(/^([0-1]?[0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$/),
  days_on: z.number().int().min(1).max(14),
  days_off: z.number().int().min(1).max(14),
  shift_offset: z.number().int().min(0).max(13),
  ground_zero_date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/),
  is_active: z.boolean(),
  created_at: z.string().datetime(),
  updated_at: z.string().datetime(),
});

export const PorterSchema = z.object({
  id: z.number().int().positive(),
  employee_id: z.string().max(20).nullable(),
  name: z.string().min(2).max(100),
  email: z.string().email().max(255).nullable(),
  phone: z.string().max(20).nullable(),
  porter_type: z.enum(['PORTER', 'SUPERVISOR', 'SENIOR_PORTER']),
  contracted_hours_type: z.enum(['SHIFT', 'RELIEF', 'CUSTOM', 'PART_TIME']),
  weekly_contracted_hours: z.number().min(0).max(60),
  shift_id: z.number().int().positive().nullable(),
  regular_department_id: z.number().int().positive().nullable(),
  is_floor_staff: z.boolean(),
  hire_date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/).nullable(),
  is_active: z.boolean(),
  created_at: z.string().datetime(),
  updated_at: z.string().datetime(),
});

export const PorterAssignmentSchema = z.object({
  id: z.number().int().positive(),
  porter_id: z.number().int().positive(),
  department_id: z.number().int().positive().nullable(),
  service_id: z.number().int().positive().nullable(),
  assignment_type: z.enum(['PERMANENT', 'TEMPORARY', 'RELIEF', 'OVERTIME']),
  start_date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/),
  end_date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/).nullable(),
  priority: z.number().int().min(1).max(5),
  notes: z.string().nullable(),
  is_active: z.boolean(),
  created_by: z.string().max(100).nullable(),
  created_at: z.string().datetime(),
  updated_at: z.string().datetime(),
});

// ============================================================================
// REQUEST SCHEMAS
// ============================================================================

export const CreateDepartmentSchema = z.object({
  name: z.string().min(2).max(100),
  code: z.string().min(2).max(20),
  is_24_7: z.boolean().default(false),
  porters_required_day: z.number().int().positive().default(1),
  porters_required_night: z.number().int().positive().default(1),
  hours: z.array(z.object({
    day_of_week: z.number().int().min(1).max(7),
    opens_at: z.string().regex(/^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/),
    closes_at: z.string().regex(/^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/),
    porters_required: z.number().int().positive().default(1),
  })).optional().default([]),
});

export const UpdateDepartmentSchema = CreateDepartmentSchema.partial();

export const CreateServiceSchema = z.object({
  name: z.string().min(2).max(100),
  code: z.string().min(2).max(20),
  is_24_7: z.boolean().default(false),
  porters_required_day: z.number().int().positive().default(1),
  porters_required_night: z.number().int().positive().default(1),
  hours: z.array(z.object({
    day_of_week: z.number().int().min(1).max(7),
    opens_at: z.string().regex(/^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/),
    closes_at: z.string().regex(/^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/),
    porters_required: z.number().int().positive().default(1),
  })).optional().default([]),
});

export const UpdateServiceSchema = CreateServiceSchema.partial();

export const CreatePorterSchema = z.object({
  employee_id: z.string().max(20).optional(),
  name: z.string().min(2).max(100),
  email: z.string().email().max(255).optional(),
  phone: z.string().max(20).optional(),
  porter_type: z.enum(['PORTER', 'SUPERVISOR', 'SENIOR_PORTER']).default('PORTER'),
  contracted_hours_type: z.enum(['SHIFT', 'RELIEF', 'CUSTOM', 'PART_TIME']),
  weekly_contracted_hours: z.number().min(0).max(60).default(37.5),
  shift_id: z.number().int().positive().optional(),
  regular_department_id: z.number().int().positive().optional(),
  is_floor_staff: z.boolean().default(false),
  hire_date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/).optional(),
});

export const UpdatePorterSchema = CreatePorterSchema.partial();

export const CreateAssignmentSchema = z.object({
  porter_id: z.number().int().positive(),
  department_id: z.number().int().positive().optional(),
  service_id: z.number().int().positive().optional(),
  assignment_type: z.enum(['PERMANENT', 'TEMPORARY', 'RELIEF', 'OVERTIME']),
  start_date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/),
  end_date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/).optional(),
  priority: z.number().int().min(1).max(5).default(1),
  notes: z.string().optional(),
}).refine(
  (data) => (data.department_id && !data.service_id) || (!data.department_id && data.service_id),
  { message: "Either department_id or service_id must be provided, but not both" }
);

// ============================================================================
// QUERY SCHEMAS
// ============================================================================

export const PaginationSchema = z.object({
  page: z.coerce.number().int().positive().default(1),
  limit: z.coerce.number().int().min(1).max(100).default(20),
  sort: z.string().optional(),
  order: z.enum(['asc', 'desc']).default('asc'),
});

export const DateRangeSchema = z.object({
  start_date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/),
  end_date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/),
}).refine(
  (data) => new Date(data.start_date) <= new Date(data.end_date),
  { message: "start_date must be before or equal to end_date" }
);

// ============================================================================
// TYPE EXPORTS
// ============================================================================

export type Department = z.infer<typeof DepartmentSchema>;
export type Service = z.infer<typeof ServiceSchema>;
export type DepartmentHours = z.infer<typeof DepartmentHoursSchema>;
export type ServiceHours = z.infer<typeof ServiceHoursSchema>;
export type Shift = z.infer<typeof ShiftSchema>;
export type Porter = z.infer<typeof PorterSchema>;
export type PorterAssignment = z.infer<typeof PorterAssignmentSchema>;

export type CreateDepartmentRequest = z.infer<typeof CreateDepartmentSchema>;
export type UpdateDepartmentRequest = z.infer<typeof UpdateDepartmentSchema>;
export type CreateServiceRequest = z.infer<typeof CreateServiceSchema>;
export type UpdateServiceRequest = z.infer<typeof UpdateServiceSchema>;
export type CreatePorterRequest = z.infer<typeof CreatePorterSchema>;
export type UpdatePorterRequest = z.infer<typeof UpdatePorterSchema>;
export type CreateAssignmentRequest = z.infer<typeof CreateAssignmentSchema>;

export type PaginationQuery = z.infer<typeof PaginationSchema>;
export type DateRangeQuery = z.infer<typeof DateRangeSchema>;
