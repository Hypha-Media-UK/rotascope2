// Core entity types
export interface Department {
  id: number;
  name: string;
  is_24_7: boolean;
  porters_required: number;
  created_at: Date;
  updated_at: Date;
}

export interface Service {
  id: number;
  name: string;
  is_24_7: boolean;
  porters_required: number;
  created_at: Date;
  updated_at: Date;
}

export interface DepartmentHours {
  id: number;
  department_id: number;
  day_of_week: number; // 0=Sunday, 1=Monday, ..., 6=Saturday
  opens_at: string; // TIME format "HH:MM:SS"
  closes_at: string; // TIME format "HH:MM:SS"
  porters_required: number;
  created_at: Date;
  updated_at: Date;
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
  ground_zero: Date;
  created_at: Date;
  updated_at: Date;
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
  created_at: Date;
  updated_at: Date;
}

export interface PorterHours {
  id: number;
  porter_id: number;
  day_of_week: number; // 0=Sunday, 1=Monday, ..., 6=Saturday
  starts_at: string; // TIME format "HH:MM:SS"
  ends_at: string; // TIME format "HH:MM:SS"
  created_at: Date;
  updated_at: Date;
}

export interface PorterAnnualLeave {
  id: number;
  porter_id: number;
  start_date: Date;
  end_date: Date;
  notes: string | null;
  created_at: Date;
  updated_at: Date;
}

export interface PorterSickness {
  id: number;
  porter_id: number;
  start_date: Date;
  end_date: Date | null;
  notes: string | null;
  created_at: Date;
  updated_at: Date;
}

export interface PorterAbsence {
  id: number;
  porter_id: number;
  start_datetime: Date;
  end_datetime: Date;
  reason: string | null;
  created_at: Date;
  updated_at: Date;
}

export interface PorterAssignment {
  id: number;
  porter_id: number;
  department_id: number;
  start_date: Date;
  end_date: Date | null;
  assignment_type: 'PERMANENT' | 'TEMPORARY' | 'RELIEF';
  notes: string | null;
  created_at: Date;
  updated_at: Date;
}

// Request/Response DTOs
export interface CreateDepartmentRequest {
  name: string;
  is_24_7: boolean;
  porters_required: number;
  hours?: Array<{
    day_of_week: number;
    opens_at: string;
    closes_at: string;
    porters_required: number;
  }>;
}

export interface CreateServiceRequest {
  name: string;
  is_24_7: boolean;
  porters_required: number;
  hours?: Array<{
    day_of_week: number;
    opens_at: string;
    closes_at: string;
    porters_required: number;
  }>;
}

export interface CreatePorterRequest {
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

export interface CreateShiftRequest {
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

export interface CreateAssignmentRequest {
  porter_id: number;
  department_id: number;
  start_date: string; // Date string
  end_date?: string; // Date string
  assignment_type: 'PERMANENT' | 'TEMPORARY' | 'RELIEF';
  notes?: string;
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

// Staffing analysis types
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
