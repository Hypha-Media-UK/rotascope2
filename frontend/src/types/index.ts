// Core entity types (matching backend)
export interface Department {
  id: number;
  name: string;
  code: string;
  is_24_7: boolean;
  porters_required_day: number;
  porters_required_night: number;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface Service {
  id: number;
  name: string;
  code: string;
  is_24_7: boolean;
  porters_required_day: number;
  porters_required_night: number;
  is_active: boolean;
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
  shift_identifier: 'A' | 'B' | 'C' | 'D';
  starts_at: string; // TIME format "HH:MM:SS"
  ends_at: string; // TIME format "HH:MM:SS"
  days_on: number;
  days_off: number;
  shift_offset: number;
  ground_zero_date: string; // Date string
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface Porter {
  id: number;
  employee_id?: string;
  name: string;
  email?: string;
  phone?: string;
  porter_type: 'REGULAR' | 'RELIEF';
  contracted_hours_type: 'SHIFT' | 'RELIEF' | 'CUSTOM' | 'PART_TIME';
  weekly_contracted_hours: number;
  shift_id?: number;
  porter_offset?: number;
  regular_department_id?: number;
  temp_department_id?: number;
  temp_service_id?: number;
  temp_assignment_start?: string;
  temp_assignment_end?: string;
  is_floor_staff: boolean;
  is_active: boolean;
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
  porters_required_day: number;
  porters_required_night: number;
  hours: Array<{
    day_of_week: number;
    opens_at: string;
    closes_at: string;
    porters_required: number;
  }>;
}

export interface ServiceFormData {
  name: string;
  code?: string;
  is_24_7: boolean;
  porters_required_day: number;
  porters_required_night: number;
}

export interface PorterFormData {
  name: string;
  email?: string;
  porter_type: 'REGULAR' | 'RELIEF';
  contracted_hours_type: 'SHIFT' | 'RELIEF' | 'CUSTOM' | 'PART_TIME';
  weekly_contracted_hours?: number;
  shift_id?: number;
  porter_offset?: number;
  regular_department_id?: number;
  temp_department_id?: number;
  temp_service_id?: number;
  temp_assignment_start?: string;
  temp_assignment_end?: string;
  is_active: boolean;
}

export interface ShiftFormData {
  name: string;
  shift_type: 'DAY' | 'NIGHT';
  shift_identifier: 'A' | 'B' | 'C' | 'D';
  starts_at: string;
  ends_at: string;
  days_on: number;
  days_off: number;
  shift_offset?: number;
  ground_zero_date: string;
  is_active: boolean;
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

// Home page types
export interface WeekTab {
  label: string; // "w/c 29/09/25"
  start_date: Date;
  is_current: boolean;
}

export interface ActiveShift {
  shift: Shift;
  assigned_porters: Array<{
    porter: Porter;
    is_active_today: boolean;
    is_temporarily_assigned: boolean;
    temp_assignment_location?: string; // Department or Service name
  }>;
  is_active_today: boolean;
}

export interface ScheduleDay {
  date: string;
  departments: Department[];
  services: Service[];
  active_shifts: ActiveShift[];
  frozen_at?: string; // When this day was frozen
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
