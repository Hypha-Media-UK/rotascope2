<template>
  <div class="modal-overlay" @click.self="$emit('close')">
    <div class="modal">
      <div class="modal-header">
        <h2 class="modal-title">{{ isEditing ? 'Edit Porter' : 'Create Porter' }}</h2>
        <button @click="$emit('close')" class="btn btn-sm btn-secondary">✕</button>
      </div>

      <!-- Tab Navigation -->
      <div class="tab-nav">
        <button
          type="button"
          @click="activeTab = 'basic'"
          :class="['tab-button', { 'tab-button--active': activeTab === 'basic' }]"
        >
          Basic Info
        </button>
        <button
          type="button"
          @click="activeTab = 'assignments'"
          :class="['tab-button', { 'tab-button--active': activeTab === 'assignments' }]"
        >
          Assignments
        </button>
      </div>

      <form @submit.prevent="handleSubmit" class="modal-body">
        <div v-if="error" class="alert alert-error">
          {{ error }}
        </div>

        <!-- Basic Info Tab -->
        <div v-if="activeTab === 'basic'" class="tab-content">

        <div class="form-group">
          <label for="name">Name *</label>
          <input
            id="name"
            v-model="formData.name"
            type="text"
            required
            placeholder="Enter full name"
            class="form-input"
          />
        </div>

        <div class="form-group">
          <label for="email">Email</label>
          <input
            id="email"
            v-model="formData.email"
            type="email"
            placeholder="Enter email address"
            class="form-input"
          />
        </div>

        <div class="form-row">
          <div class="form-group">
            <label for="porter-type">Porter Type *</label>
            <select
              id="porter-type"
              v-model="formData.porter_type"
              required
              class="form-input"
            >
              <option value="">Select type</option>
              <option value="REGULAR">Regular</option>
              <option value="RELIEF">Relief</option>
            </select>
          </div>

          <div class="form-group">
            <label for="contract-type">Contract Type *</label>
            <select
              id="contract-type"
              v-model="formData.contracted_hours_type"
              required
              class="form-input"
            >
              <option value="">Select contract</option>
              <option value="SHIFT">Shift Worker</option>
              <option value="RELIEF">Relief Worker</option>
              <option value="CUSTOM">Custom Hours</option>
              <option value="PART_TIME">Part Time</option>
            </select>
          </div>
        </div>

        <div class="form-group">
          <label for="weekly-hours">Weekly Contracted Hours</label>
          <input
            id="weekly-hours"
            v-model.number="formData.weekly_contracted_hours"
            type="number"
            min="1"
            max="60"
            step="0.5"
            placeholder="Enter hours per week"
            class="form-input"
          />
        </div>



          <div class="form-group">
            <label class="checkbox-label">
              <input
                v-model="formData.is_active"
                type="checkbox"
                class="form-checkbox"
              />
              Active Porter
            </label>
          </div>
        </div>

        <!-- Assignments Tab -->
        <div v-if="activeTab === 'assignments'" class="tab-content">
          <h3 class="section-title">Shift Assignment</h3>

          <div class="form-row">
            <div class="form-group">
              <label for="shift">Assigned Shift</label>
              <select
                id="shift"
                v-model="formData.shift_id"
                class="form-select"
              >
                <option value="">No shift assignment</option>
                <option v-for="shift in shifts" :key="shift.id" :value="shift.id">
                  {{ shift.name }}
                </option>
              </select>
            </div>

            <div class="form-group">
              <label for="porter-offset">Porter Offset (days)</label>
              <input
                id="porter-offset"
                v-model.number="formData.porter_offset"
                type="number"
                min="0"
                max="13"
                placeholder="0"
                class="form-input"
              />
              <small class="form-help">Days to offset from shift start (for straddling shifts)</small>
            </div>
          </div>

          <div class="form-group">
            <label for="regular-department">Regular Department</label>
            <select
              id="regular-department"
              v-model="formData.regular_department_id"
              class="form-select"
            >
              <option value="">No department assignment</option>
              <option v-for="department in departments" :key="department.id" :value="department.id">
                {{ department.name }}
              </option>
            </select>
          </div>

          <h3 class="section-title">Temporary Assignment</h3>
          <p class="section-description">Temporary assignments override shift assignments for the specified period.</p>

          <div class="form-row">
            <div class="form-group">
              <label for="temp-department">Temporary Department</label>
              <select
                id="temp-department"
                v-model="formData.temp_department_id"
                class="form-select"
                :disabled="!!formData.temp_service_id"
              >
                <option value="">No temporary department</option>
                <option v-for="department in departments" :key="department.id" :value="department.id">
                  {{ department.name }}
                </option>
              </select>
            </div>

            <div class="form-group">
              <label for="temp-service">Temporary Service</label>
              <select
                id="temp-service"
                v-model="formData.temp_service_id"
                class="form-select"
                :disabled="!!formData.temp_department_id"
              >
                <option value="">No temporary service</option>
                <option v-for="service in services" :key="service.id" :value="service.id">
                  {{ service.name }}
                </option>
              </select>
            </div>
          </div>

          <div v-if="formData.temp_department_id || formData.temp_service_id" class="form-row">
            <div class="form-group">
              <label for="temp-start">Start Date *</label>
              <input
                id="temp-start"
                v-model="formData.temp_assignment_start"
                type="date"
                required
                class="form-input"
              />
            </div>

            <div class="form-group">
              <label for="temp-end">End Date *</label>
              <input
                id="temp-end"
                v-model="formData.temp_assignment_end"
                type="date"
                required
                class="form-input"
              />
            </div>
          </div>
        </div>

      </form>

      <div class="modal-footer">
        <button type="button" @click="$emit('close')" class="btn btn-secondary" :disabled="loading">
          Cancel
        </button>
        <button @click="handleSubmit" class="btn btn-primary" :disabled="loading">
          {{ loading ? 'Saving...' : (isEditing ? 'Update Porter' : 'Create Porter') }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted } from 'vue'
import type { Porter, PorterFormData, Shift, Department, Service } from '@/types'
import { shiftApi, departmentApi, serviceApi } from '@/services/api'

interface Props {
  porter?: Porter | null
}

interface Emits {
  (e: 'save', data: PorterFormData): void
  (e: 'close'): void
}

const props = defineProps<Props>()
const emit = defineEmits<Emits>()

// Tab state
const activeTab = ref<'basic' | 'assignments'>('basic')

// Data for dropdowns
const shifts = ref<Shift[]>([])
const departments = ref<Department[]>([])
const services = ref<Service[]>([])
const loadingData = ref(false)

const loading = ref(false)
const error = ref<string | null>(null)

const formData = ref<PorterFormData>({
  name: '',
  email: '',
  porter_type: 'REGULAR',
  contracted_hours_type: 'SHIFT',
  weekly_contracted_hours: 37.5,
  shift_id: undefined,
  porter_offset: 0,
  regular_department_id: undefined,
  temp_department_id: undefined,
  temp_service_id: undefined,
  temp_assignment_start: undefined,
  temp_assignment_end: undefined,
  is_active: true
})

const isEditing = computed(() => props.porter !== null)

// Helper functions for date formatting
function formatDateForInput(dateString: string | null | undefined): string | undefined {
  if (!dateString) return undefined
  // Convert ISO datetime string to YYYY-MM-DD format for date inputs
  return dateString.split('T')[0]
}

function formatDateForAPI(dateString: string | undefined): string | undefined {
  if (!dateString) return undefined
  // Convert YYYY-MM-DD to ISO datetime string for API
  return new Date(dateString + 'T00:00:00.000Z').toISOString()
}

function initializeForm() {
  if (props.porter) {
    formData.value = {
      name: props.porter.name,
      email: props.porter.email || '',
      porter_type: props.porter.porter_type,
      contracted_hours_type: props.porter.contracted_hours_type,
      weekly_contracted_hours: props.porter.weekly_contracted_hours,
      shift_id: props.porter.shift_id,
      porter_offset: props.porter.porter_offset || 0,
      regular_department_id: props.porter.regular_department_id,
      temp_department_id: props.porter.temp_department_id,
      temp_service_id: props.porter.temp_service_id,
      temp_assignment_start: formatDateForInput(props.porter.temp_assignment_start),
      temp_assignment_end: formatDateForInput(props.porter.temp_assignment_end),
      is_active: Boolean(props.porter.is_active)
    }
  } else {
    formData.value = {
      name: '',
      email: '',
      porter_type: 'REGULAR',
      contracted_hours_type: 'SHIFT',
      weekly_contracted_hours: 37.5,
      shift_id: undefined,
      porter_offset: 0,
      regular_department_id: undefined,
      temp_department_id: undefined,
      temp_service_id: undefined,
      temp_assignment_start: undefined,
      temp_assignment_end: undefined,
      is_active: true
    }
  }
}

// Load dropdown data
async function loadDropdownData() {
  try {
    loadingData.value = true
    const [shiftsData, departmentsData, servicesData] = await Promise.all([
      shiftApi.getAll(),
      departmentApi.getAll(),
      serviceApi.getAll()
    ])
    shifts.value = shiftsData
    departments.value = departmentsData
    services.value = servicesData
  } catch (err) {
    console.error('Error loading dropdown data:', err)
  } finally {
    loadingData.value = false
  }
}

// Clear temporary assignment when switching between department/service
watch(() => formData.value.temp_department_id, (newVal) => {
  if (newVal) {
    formData.value.temp_service_id = undefined
  }
})

watch(() => formData.value.temp_service_id, (newVal) => {
  if (newVal) {
    formData.value.temp_department_id = undefined
  }
})

// Clear temp assignment dates when no temp assignment selected
watch(() => [formData.value.temp_department_id, formData.value.temp_service_id], ([dept, service]) => {
  if (!dept && !service) {
    formData.value.temp_assignment_start = undefined
    formData.value.temp_assignment_end = undefined
  }
})

watch(() => props.porter, () => {
  initializeForm()
}, { immediate: true })

async function handleSubmit() {
  error.value = null
  loading.value = true

  try {
    // Validate temporary assignment dates
    if ((formData.value.temp_department_id || formData.value.temp_service_id)) {
      if (!formData.value.temp_assignment_start || !formData.value.temp_assignment_end) {
        throw new Error('Start and end dates are required for temporary assignments')
      }
      if (new Date(formData.value.temp_assignment_start) >= new Date(formData.value.temp_assignment_end)) {
        throw new Error('End date must be after start date')
      }
    }

    // Prepare data for API with properly formatted dates
    const apiData = {
      ...formData.value,
      temp_assignment_start: formatDateForAPI(formData.value.temp_assignment_start),
      temp_assignment_end: formatDateForAPI(formData.value.temp_assignment_end)
    }

    await emit('save', apiData)
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to save porter'
  } finally {
    loading.value = false
  }
}

// Load data on mount
onMounted(() => {
  loadDropdownData()
})
</script>

<style scoped>
.modal {
  width: 90%;
  max-width: 600px;
}

.tab-nav {
  display: flex;
  border-bottom: 1px solid var(--color-neutral-200);
  background-color: var(--color-neutral-50);
}

.tab-button {
  flex: 1;
  padding: var(--space-3) var(--space-4);
  border: none;
  background: transparent;
  color: var(--color-neutral-600);
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  border-bottom: 2px solid transparent;
}

.tab-button:hover {
  background-color: var(--color-neutral-100);
  color: var(--color-neutral-900);
}

.tab-button--active {
  color: var(--color-primary);
  background-color: white;
  border-bottom-color: var(--color-primary);
}

.tab-content {
  padding-top: var(--space-4);
}

.section-title {
  font-size: var(--font-size-lg);
  font-weight: 600;
  color: var(--color-neutral-900);
  margin: var(--space-6) 0 var(--space-3) 0;
  padding-bottom: var(--space-2);
  border-bottom: 1px solid var(--color-neutral-200);
}

.section-title:first-child {
  margin-top: 0;
}

.section-description {
  color: var(--color-neutral-600);
  font-size: var(--font-size-sm);
  margin: 0 0 var(--space-4) 0;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--space-4);
}

.form-help {
  display: block;
  margin-top: var(--space-1);
  font-size: var(--font-size-xs);
  color: var(--color-neutral-500);
}

.checkbox-label {
  display: flex;
  align-items: center;
  gap: var(--space-2);
  cursor: pointer;
}

.form-checkbox {
  width: auto;
}
</style>
