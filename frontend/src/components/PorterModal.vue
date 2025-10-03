<template>
  <div class="modal-overlay" @click.self="$emit('close')">
    <div class="modal">
      <div class="modal-header">
        <h2 class="modal-title">
          {{ props.quickAssignmentMode ? `Reassign ${props.porter?.name || 'Porter'}` : (isEditing ? 'Edit Porter' : 'Create Porter') }}
        </h2>
        <button @click="$emit('close')" class="btn btn-sm btn-secondary">✕</button>
      </div>

      <!-- Tab Navigation -->
      <div v-if="!props.quickAssignmentMode" class="tab-nav">
        <button
          type="button"
          @click="activeTab = 'assignments'"
          :class="['tab-button', { 'tab-button--active': activeTab === 'assignments' }]"
        >
          Assignments
        </button>
        <button
          type="button"
          @click="activeTab = 'basic'"
          :class="['tab-button', { 'tab-button--active': activeTab === 'basic' }]"
        >
          Basic Info
        </button>
      </div>

      <!-- Quick Assignment Mode Header -->
      <div v-if="props.quickAssignmentMode" class="quick-assignment-header">
        <h3>Temporary Assignment</h3>
        <p class="quick-assignment-subtitle">Make temporary changes without affecting permanent settings</p>
      </div>

      <form @submit.prevent="handleSubmit" class="modal-body">
        <div v-if="error" class="alert alert-error">
          {{ error }}
        </div>

        <!-- Basic Info Tab -->
        <div v-if="activeTab === 'basic' && !props.quickAssignmentMode" class="tab-content">

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
              <option value="PORTER">Porter</option>
              <option value="SUPERVISOR">Supervisor</option>
              <option value="SENIOR_PORTER">Senior Porter</option>
            </select>
          </div>


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
        <div v-if="activeTab === 'assignments' || props.quickAssignmentMode" class="tab-content">
          <h3 v-if="!props.quickAssignmentMode" class="section-title">Shift Assignment</h3>

          <div v-if="!props.quickAssignmentMode" class="form-row">
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
          </div>

          <div v-if="!props.quickAssignmentMode" class="form-row-with-divider">
            <div class="form-group">
              <label for="regular-department">Regular Department</label>
              <select
                id="regular-department"
                v-model="formData.regular_department_id"
                class="form-select"
                :disabled="!!formData.regular_service_id"
              >
                <option value="">No department assignment</option>
                <option v-for="department in departments" :key="department.id" :value="department.id">
                  {{ department.name }}
                </option>
              </select>
            </div>

            <div class="divider">
              <span class="divider-text">Or</span>
            </div>

            <div class="form-group">
              <label for="regular-service">Regular Service</label>
              <select
                id="regular-service"
                v-model="formData.regular_service_id"
                class="form-select"
                :disabled="!!formData.regular_department_id"
              >
                <option value="">No service assignment</option>
                <option v-for="service in services" :key="service.id" :value="service.id">
                  {{ service.name }}
                </option>
              </select>
            </div>
          </div>

          <!-- Custom Hours Section -->
          <div v-if="!props.quickAssignmentMode" class="form-group">
            <label class="checkbox-label">
              <input
                type="checkbox"
                v-model="formData.has_custom_hours"
                class="form-checkbox"
              />
              <span class="checkbox-text">Custom Hours</span>
            </label>
            <p class="field-help">Check this if the porter has non-standard working hours</p>
          </div>

          <!-- Custom Hours Section (only show when Custom Hours checkbox is checked) -->
          <div v-if="formData.has_custom_hours && !props.quickAssignmentMode" class="custom-hours-section">
            <div class="section-header">
              <h3 class="section-title">Custom Working Hours</h3>
              <button
                type="button"
                @click="addCustomHour"
                class="btn btn-sm btn-secondary"
              >
                Add Hours
              </button>
            </div>

            <div v-if="formData.custom_hours.length === 0" class="empty-hours">
              <p>No custom hours set. Click "Add Hours" to get started.</p>
            </div>

            <div v-else class="hours-list">
              <div
                v-for="(hour, index) in formData.custom_hours"
                :key="index"
                class="hour-item"
              >
                <div class="hour-fields">
                  <div class="field-group">
                    <label class="field-label">Day</label>
                    <select v-model.number="hour.day_of_week" class="form-select">
                      <option
                        v-for="(dayName, dayIndex) in DAY_NAMES"
                        :key="dayIndex"
                        :value="dayIndex"
                      >
                        {{ dayName }}
                      </option>
                    </select>
                  </div>

                  <div class="field-group">
                    <label class="field-label">Starts</label>
                    <input
                      v-model="hour.starts_at"
                      type="time"
                      class="form-input"
                      required
                    />
                  </div>

                  <div class="field-group">
                    <label class="field-label">Ends</label>
                    <input
                      v-model="hour.ends_at"
                      type="time"
                      class="form-input"
                      required
                    />
                  </div>

                  <div class="field-group">
                    <button
                      type="button"
                      @click="removeCustomHour(index)"
                      class="btn btn-sm btn-danger"
                      title="Remove this time period"
                    >
                      ✕
                    </button>
                  </div>
                </div>
              </div>
            </div>
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
import type { Porter, PorterFormData, PorterHoursFormData, Shift, Department, Service } from '@/types'
import { DAY_NAMES } from '@/types'
import { shiftApi, departmentApi, serviceApi } from '@/services/api'

interface Props {
  porter?: Porter | null
  quickAssignmentMode?: boolean
}

interface Emits {
  (e: 'save', data: PorterFormData): void
  (e: 'close'): void
}

const props = defineProps<Props>()
const emit = defineEmits<Emits>()

// Tab state
const activeTab = ref<'basic' | 'assignments'>('assignments')

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
  porter_type: 'PORTER',
  weekly_contracted_hours: 37.5,
  has_custom_hours: false,
  shift_id: undefined,
  porter_offset: 0,
  regular_department_id: undefined,
  regular_service_id: undefined,
  temp_department_id: undefined,
  temp_service_id: undefined,
  temp_assignment_start: undefined,
  temp_assignment_end: undefined,
  is_active: true,
  custom_hours: []
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
      weekly_contracted_hours: props.porter.weekly_contracted_hours,
      has_custom_hours: Boolean(props.porter.has_custom_hours),
      shift_id: props.porter.shift_id,
      porter_offset: props.porter.porter_offset || 0,
      regular_department_id: props.porter.regular_department_id,
      regular_service_id: props.porter.regular_service_id,
      temp_department_id: props.porter.temp_department_id,
      temp_service_id: props.porter.temp_service_id,
      temp_assignment_start: formatDateForInput(props.porter.temp_assignment_start),
      temp_assignment_end: formatDateForInput(props.porter.temp_assignment_end),
      is_active: Boolean(props.porter.is_active),
      custom_hours: [] // Will be loaded from API if porter has custom hours
    }

    // Load custom hours if porter has custom hours enabled
    if (props.porter.has_custom_hours) {
      loadCustomHours(props.porter.id)
    }
  } else {
    formData.value = {
      name: '',
      email: '',
      porter_type: 'PORTER',
      weekly_contracted_hours: 37.5,
      has_custom_hours: false,
      shift_id: undefined,
      porter_offset: 0,
      regular_department_id: undefined,
      regular_service_id: undefined,
      temp_department_id: undefined,
      temp_service_id: undefined,
      temp_assignment_start: undefined,
      temp_assignment_end: undefined,
      is_active: true,
      custom_hours: []
    }
  }
}

// Custom hours management
function addCustomHour() {
  formData.value.custom_hours.push({
    day_of_week: 1, // Monday
    starts_at: '08:00',
    ends_at: '17:00'
  })
}

function removeCustomHour(index: number) {
  formData.value.custom_hours.splice(index, 1)
}

// Load custom hours for editing porter
async function loadCustomHours(porterId: number) {
  try {
    const response = await fetch(`/api/porters/${porterId}/hours`)
    if (response.ok) {
      const hours = await response.json()
      formData.value.custom_hours = hours.map((hour: any) => ({
        day_of_week: hour.day_of_week,
        starts_at: hour.starts_at.substring(0, 5), // Convert "HH:MM:SS" to "HH:MM"
        ends_at: hour.ends_at.substring(0, 5)
      }))
    }
  } catch (error) {
    console.error('Error loading custom hours:', error)
  }
}

// Save custom hours
async function saveCustomHours(porterId: number) {
  try {
    const response = await fetch(`/api/porters/${porterId}/hours`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        hours: formData.value.custom_hours
      })
    })

    if (!response.ok) {
      throw new Error('Failed to save custom hours')
    }
  } catch (error) {
    console.error('Error saving custom hours:', error)
    throw error
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

    // Save custom hours if custom hours is enabled and we're editing a porter
    if (formData.value.has_custom_hours && isEditing.value && props.porter) {
      await saveCustomHours(props.porter.id)
    }
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

.checkbox-label {
  display: flex;
  align-items: center;
  gap: var(--space-2);
  cursor: pointer;
  margin-top: var(--space-2);
}

.form-checkbox {
  width: 18px;
  height: 18px;
  cursor: pointer;
}

.checkbox-text {
  font-weight: var(--font-weight-medium);
  color: var(--color-text-primary);
}

.field-help {
  font-size: var(--font-size-sm);
  color: var(--color-text-secondary);
  margin: var(--space-1) 0 0 0;
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

/* Custom Hours Styles */
.custom-hours-section {
  margin-top: var(--space-6);
  padding: var(--space-4);
  background-color: var(--color-neutral-50);
  border-radius: var(--radius-md);
  border: 1px solid var(--color-neutral-200);
}

.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: var(--space-4);
}

.section-title {
  font-size: var(--font-size-lg);
  font-weight: 600;
  color: var(--color-neutral-900);
  margin: 0;
}

.empty-hours {
  text-align: center;
  padding: var(--space-8);
  color: var(--color-neutral-600);
  background-color: var(--color-neutral-25);
  border-radius: var(--radius-md);
  border: 2px dashed var(--color-neutral-200);
}

.hours-list {
  display: flex;
  flex-direction: column;
  gap: var(--space-3);
}

.hour-item {
  padding: var(--space-3);
  border: 1px solid var(--color-neutral-200);
  border-radius: var(--radius-md);
  background-color: white;
}

.hour-fields {
  display: grid;
  grid-template-columns: 2fr 1fr 1fr auto;
  gap: var(--space-3);
  align-items: end;
}

@media (max-width: 768px) {
  .hour-fields {
    grid-template-columns: 1fr;
    gap: var(--space-3);
  }
}

.field-group {
  display: flex;
  flex-direction: column;
  gap: var(--space-1);
}

.field-label {
  font-size: var(--font-size-xs);
  font-weight: 500;
  color: var(--color-neutral-700);
}

.btn-danger {
  background-color: var(--color-red-600);
  color: white;
  border: 1px solid var(--color-red-600);
}

.btn-danger:hover {
  background-color: var(--color-red-700);
  border-color: var(--color-red-700);
}

/* Form Row with Divider Styles */
.form-row-with-divider {
  display: flex;
  align-items: flex-end;
  gap: var(--space-4);
}

.form-row-with-divider .form-group {
  flex: 1;
}

.divider {
  display: flex;
  align-items: center;
  justify-content: center;
  min-width: 40px;
  height: 40px;
  margin-bottom: 0;
}

.divider-text {
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
  color: var(--color-text-secondary);
  background-color: var(--color-neutral-100);
  padding: var(--space-1) var(--space-2);
  border-radius: var(--radius-full);
  border: 1px solid var(--color-neutral-200);
}

/* Quick Assignment Mode Styles */
.quick-assignment-header {
  padding: var(--space-4);
  background-color: var(--color-blue-50);
  border-radius: var(--radius-md);
  border: 1px solid var(--color-blue-200);
  margin-bottom: var(--space-6);
}

.quick-assignment-header h3 {
  margin: 0 0 var(--space-2) 0;
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-semibold);
  color: var(--color-blue-900);
}

.quick-assignment-subtitle {
  margin: 0;
  font-size: var(--font-size-sm);
  color: var(--color-blue-700);
}
</style>
