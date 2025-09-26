// Core entity types (matching backend)
export interface Department {
  id: number;
  name: string;
  is_24_7: boolean;
  porters_required: number;
  created_at: string;
  updated_at: string;
}

export interface Service {
  id: number;
  name: string;
  is_24_7: boolean;
  porters_required: number;
  created_at: string;
  updated_at: string;
}

export interface DepartmentHours {
  id: number;
  department_id: number;
  day_of_week: number; // 0=Sunday, 1=Monday, ..., 6=Saturday
  opens_at: string; // TIME format "HH:MM:SS"
  closes_at: string; // TIME format "HH:MM:SS"
  porters_required: number;
  created_at: string;
  updated_at: string;
}

export interface ServiceHours {
  id: number;
  service_id: number;
  day_of_week: number; // 0=Sunday, 1=Monday, ..., 6=Saturday
  opens_at: string; // TIME format "HH:MM:SS"
  closes_at: string; // TIME format "HH:MM:SS"
  porters_required: number;
  created_at: string;
  updated_at: string;
}

export interface Shift {
  id: number;
  name: string;
  shift_type: 'DAY' | 'NIGHT';
  shift_ident: 'A' | 'B' | 'C' | 'D';
  starts_at: string; // TIME format "HH:MM:SS"
  ends_at: string; // TIME format "HH:MM:SS"
  days_on: number;
  days_off: number;
  shift_offset: number;
  ground_zero: string; // Date string
  created_at: string;
  updated_at: string;
}

export interface Porter {
  id: number;
  name: string;
  porter_type: 'PORTER' | 'SUPERVISOR';
  contracted_hours_type: 'SHIFT' | 'CUSTOM' | 'RELIEF';
  shift_id: number | null;
  shift_offset: number;
  regular_department_id: number | null;
  is_floor_staff: boolean;
  weekly_hours: number;
  created_at: string;
  updated_at: string;
}

export interface PorterHours {
  id: number;
  porter_id: number;
  day_of_week: number; // 0=Sunday, 1=Monday, ..., 6=Saturday
  starts_at: string; // TIME format "HH:MM:SS"
  ends_at: string; // TIME format "HH:MM:SS"
  created_at: string;
  updated_at: string;
}

export interface PorterAnnualLeave {
  id: number;
  porter_id: number;
  start_date: string;
  end_date: string;
  notes: string | null;
  created_at: string;
  updated_at: string;
}

export interface PorterSickness {
  id: number;
  porter_id: number;
  start_date: string;
  end_date: string | null;
  notes: string | null;
  created_at: string;
  updated_at: string;
}

export interface PorterAbsence {
  id: number;
  porter_id: number;
  start_datetime: string;
  end_datetime: string;
  reason: string | null;
  created_at: string;
  updated_at: string;
}

export interface PorterAssignment {
  id: number;
  porter_id: number;
  department_id: number | null;
  service_id: number | null;
  start_date: string;
  end_date: string | null;
  assignment_type: 'PERMANENT' | 'TEMPORARY' | 'RELIEF';
  notes: string | null;
  created_at: string;
  updated_at: string;
}

// Extended types with relationships
export interface DepartmentWithHours extends Department {
  hours: DepartmentHours[];
}

export interface PorterWithDetails extends Porter {
  shift?: Shift;
  regular_department?: Department;
  custom_hours: PorterHours[];
  annual_leave: PorterAnnualLeave[];
  sickness: PorterSickness[];
  absences: PorterAbsence[];
  assignments: (PorterAssignment & { department: Department })[];
}

// Form data types
export interface DepartmentFormData {
  name: string;
  is_24_7: boolean;
  porters_required: number;
  hours: Array<{
    day_of_week: number;
    opens_at: string;
    closes_at: string;
    porters_required: number;
  }>;
}

export interface ServiceFormData {
  name: string;
  is_24_7: boolean;
  porters_required: number;
  hours: Array<{
    day_of_week: number;
    opens_at: string;
    closes_at: string;
    porters_required: number;
  }>;
}

export interface PorterFormData {
  name: string;
  porter_type: 'PORTER' | 'SUPERVISOR';
  contracted_hours_type: 'SHIFT' | 'CUSTOM' | 'RELIEF';
  shift_id?: number;
  shift_offset?: number;
  regular_department_id?: number;
  is_floor_staff: boolean;
  weekly_hours?: number;
  custom_hours?: Array<{
    day_of_week: number;
    starts_at: string;
    ends_at: string;
  }>;
}

export interface ShiftFormData {
  name: string;
  shift_type: 'DAY' | 'NIGHT';
  shift_ident: 'A' | 'B' | 'C' | 'D';
  starts_at: string;
  ends_at: string;
  days_on: number;
  days_off: number;
  shift_offset: number;
  ground_zero: string; // Date string
}

export interface AssignmentFormData {
  porter_id: number;
  department_id?: number;
  service_id?: number;
  start_date: string;
  end_date?: string;
  assignment_type: 'PERMANENT' | 'TEMPORARY' | 'RELIEF';
  notes?: string;
}

// UI state types
export interface StaffingAlert {
  type: 'LOW_STAFFING' | 'UNAVAILABLE_PORTER' | 'OVERLAP_CONFLICT';
  department_id: number;
  department_name: string;
  date: string;
  time_period: {
    start: string;
    end: string;
  };
  required_porters: number;
  available_porters: number;
  message: string;
  affected_porters: Array<{
    porter_id: number;
    porter_name: string;
    issue: string;
  }>;
}

export interface DaySchedule {
  date: string;
  departments: Array<{
    department: DepartmentWithHours;
    assigned_porters: Array<{
      porter: PorterWithDetails;
      assignment: PorterAssignment;
      working_hours: {
        start: string;
        end: string;
      };
      is_available: boolean;
      unavailability_reason?: string;
    }>;
    staffing_alerts: StaffingAlert[];
    is_adequately_staffed: boolean;
  }>;
}

// API response types
export interface ApiResponse<T> {
  data?: T;
  error?: {
    message: string;
    status: number;
  };
}

// Utility types
export type DayOfWeek = 0 | 1 | 2 | 3 | 4 | 5 | 6;

export const DAY_NAMES = [
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday'
] as const;

export const SHIFT_TYPES = ['DAY', 'NIGHT'] as const;
export const SHIFT_IDENTS = ['A', 'B', 'C', 'D'] as const;
export const PORTER_TYPES = ['PORTER', 'SUPERVISOR'] as const;
export const CONTRACTED_HOURS_TYPES = ['SHIFT', 'CUSTOM', 'RELIEF'] as const;
export const ASSIGNMENT_TYPES = ['PERMANENT', 'TEMPORARY', 'RELIEF'] as const;
