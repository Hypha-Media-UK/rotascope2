import type {
  Department,
  DepartmentWithHours,
  Service,
  Porter,
  PorterWithDetails,
  Shift,
  ShiftType,
  ShiftTypeFormData,
  PorterAssignment,
  DepartmentFormData,
  ServiceFormData,
  PorterFormData,
  ShiftFormData,
  AssignmentFormData,
  ApiResponse
} from '@/types';

const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:3001';

class ApiError extends Error {
  constructor(public status: number, message: string) {
    super(message);
    this.name = 'ApiError';
  }
}

async function apiRequest<T>(
  endpoint: string,
  options: RequestInit = {}
): Promise<T> {
  const url = `${API_BASE_URL}${endpoint}`;

  const config: RequestInit = {
    headers: {
      'Content-Type': 'application/json',
      ...options.headers,
    },
    ...options,
  };

  try {
    const response = await fetch(url, config);

    if (!response.ok) {
      const errorData = await response.json().catch(() => ({}));
      throw new ApiError(
        response.status,
        errorData.error?.message || `HTTP ${response.status}: ${response.statusText}`
      );
    }

    // Handle 204 No Content responses
    if (response.status === 204) {
      return undefined as T;
    }

    return await response.json();
  } catch (error) {
    if (error instanceof ApiError) {
      throw error;
    }

    // Network or other errors
    throw new ApiError(0, `Network error: ${error instanceof Error ? error.message : 'Unknown error'}`);
  }
}

// Department API
export const departmentApi = {
  async getAll(): Promise<DepartmentWithHours[]> {
    return apiRequest<DepartmentWithHours[]>('/api/departments');
  },

  async getById(id: number): Promise<DepartmentWithHours> {
    return apiRequest<DepartmentWithHours>(`/api/departments/${id}`);
  },

  async create(data: DepartmentFormData): Promise<DepartmentWithHours> {
    return apiRequest<DepartmentWithHours>('/api/departments', {
      method: 'POST',
      body: JSON.stringify(data),
    });
  },

  async update(id: number, data: DepartmentFormData): Promise<DepartmentWithHours> {
    return apiRequest<DepartmentWithHours>(`/api/departments/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data),
    });
  },

  async delete(id: number): Promise<void> {
    return apiRequest<void>(`/api/departments/${id}`, {
      method: 'DELETE',
    });
  },
};

// Service API
export const serviceApi = {
  async getAll(): Promise<Service[]> {
    return apiRequest<Service[]>('/api/services');
  },

  async getById(id: number): Promise<Service> {
    return apiRequest<Service>(`/api/services/${id}`);
  },

  async create(data: ServiceFormData): Promise<Service> {
    return apiRequest<Service>('/api/services', {
      method: 'POST',
      body: JSON.stringify(data),
    });
  },

  async update(id: number, data: ServiceFormData): Promise<Service> {
    return apiRequest<Service>(`/api/services/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data),
    });
  },

  async delete(id: number): Promise<void> {
    return apiRequest<void>(`/api/services/${id}`, {
      method: 'DELETE',
    });
  },
};

// Porter API
export const porterApi = {
  async getAll(): Promise<Porter[]> {
    return apiRequest<Porter[]>('/api/porters');
  },

  async getById(id: number): Promise<PorterWithDetails> {
    return apiRequest<PorterWithDetails>(`/api/porters/${id}`);
  },

  async create(data: PorterFormData): Promise<Porter> {
    return apiRequest<Porter>('/api/porters', {
      method: 'POST',
      body: JSON.stringify(data),
    });
  },

  async update(id: number, data: PorterFormData): Promise<Porter> {
    return apiRequest<Porter>(`/api/porters/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data),
    });
  },

  async delete(id: number): Promise<void> {
    return apiRequest<void>(`/api/porters/${id}`, {
      method: 'DELETE',
    });
  },
};

// Shift Type API
export const shiftTypeApi = {
  async getAll(): Promise<ShiftType[]> {
    return apiRequest<ShiftType[]>('/api/shift-types');
  },

  async getById(id: number): Promise<ShiftType> {
    return apiRequest<ShiftType>(`/api/shift-types/${id}`);
  },

  async create(data: ShiftTypeFormData): Promise<ShiftType> {
    return apiRequest<ShiftType>('/api/shift-types', {
      method: 'POST',
      body: JSON.stringify(data),
    });
  },

  async update(id: number, data: ShiftTypeFormData): Promise<ShiftType> {
    return apiRequest<ShiftType>(`/api/shift-types/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data),
    });
  },

  async delete(id: number): Promise<void> {
    return apiRequest<void>(`/api/shift-types/${id}`, {
      method: 'DELETE',
    });
  },
};

// Shift API
export const shiftApi = {
  async getAll(): Promise<Shift[]> {
    return apiRequest<Shift[]>('/api/shifts');
  },

  async getById(id: number): Promise<Shift> {
    return apiRequest<Shift>(`/api/shifts/${id}`);
  },

  async create(data: ShiftFormData): Promise<Shift> {
    return apiRequest<Shift>('/api/shifts', {
      method: 'POST',
      body: JSON.stringify(data),
    });
  },

  async update(id: number, data: ShiftFormData): Promise<Shift> {
    return apiRequest<Shift>(`/api/shifts/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data),
    });
  },

  async delete(id: number): Promise<void> {
    return apiRequest<void>(`/api/shifts/${id}`, {
      method: 'DELETE',
    });
  },

  async getActiveShifts(date: string): Promise<Shift[]> {
    return apiRequest<Shift[]>(`/api/shifts/active/${date}`);
  }
};

// Assignment API
export const assignmentApi = {
  async getAll(): Promise<PorterAssignment[]> {
    return apiRequest<PorterAssignment[]>('/api/assignments');
  },

  async getCurrent(): Promise<PorterAssignment[]> {
    return apiRequest<PorterAssignment[]>('/api/assignments/current');
  },

  async create(data: AssignmentFormData): Promise<PorterAssignment> {
    return apiRequest<PorterAssignment>('/api/assignments', {
      method: 'POST',
      body: JSON.stringify(data),
    });
  },

  async update(id: number, data: AssignmentFormData): Promise<PorterAssignment> {
    return apiRequest<PorterAssignment>(`/api/assignments/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data),
    });
  },

  async delete(id: number): Promise<void> {
    return apiRequest<void>(`/api/assignments/${id}`, {
      method: 'DELETE',
    });
  },
};

// Health check
export const healthApi = {
  async check(): Promise<{ status: string; timestamp: string; service: string }> {
    return apiRequest<{ status: string; timestamp: string; service: string }>('/health');
  },
};

// Export the ApiError for use in components
export { ApiError };
