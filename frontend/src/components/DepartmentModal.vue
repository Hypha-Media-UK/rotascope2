<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import type { DepartmentWithHours, DepartmentFormData } from '@/types'
import { DAY_NAMES } from '@/types'

// Props & Emits
interface Props {
  department?: DepartmentWithHours | null
}

const props = defineProps<Props>()

const emit = defineEmits<{
  save: [data: DepartmentFormData]
  close: []
}>()

// State
const loading = ref(false)
const error = ref<string | null>(null)

// Form data
const formData = ref<DepartmentFormData>({
  name: '',
  is_24_7: false,
  porters_required: 1,
  hours: []
})

// Computed
const isEditing = computed(() => props.department !== null)
const modalTitle = computed(() => isEditing.value ? 'Edit Department' : 'Add Department')

// Initialize hours for all days if not 24/7
const defaultHours = DAY_NAMES.map((_, index) => ({
  day_of_week: index,
  opens_at: '08:00',
  closes_at: '17:00',
  porters_required: 1
}))

// Methods
function initializeForm() {
  if (props.department) {
    formData.value = {
      name: props.department.name,
      is_24_7: props.department.is_24_7,
      porters_required: props.department.porters_required,
      hours: props.department.hours.length > 0
        ? props.department.hours.map(h => ({
            day_of_week: h.day_of_week,
            opens_at: h.opens_at.slice(0, 5), // Remove seconds
            closes_at: h.closes_at.slice(0, 5), // Remove seconds
            porters_required: h.porters_required
          }))
        : [...defaultHours]
    }
  } else {
    formData.value = {
      name: '',
      is_24_7: false,
      porters_required: 1,
      hours: [...defaultHours]
    }
  }
}

function toggleOperationType() {
  if (formData.value.is_24_7) {
    formData.value.hours = []
  } else {
    formData.value.hours = [...defaultHours]
  }
}

function addHour() {
  formData.value.hours.push({
    day_of_week: 1, // Monday
    opens_at: '08:00',
    closes_at: '17:00',
    porters_required: 1
  })
}

function removeHour(index: number) {
  formData.value.hours.splice(index, 1)
}

async function handleSubmit() {
  try {
    loading.value = true
    error.value = null

    // Validation
    if (!formData.value.name.trim()) {
      throw new Error('Department name is required')
    }

    if (formData.value.porters_required < 1) {
      throw new Error('At least 1 porter is required')
    }

    if (!formData.value.is_24_7 && formData.value.hours.length === 0) {
      throw new Error('Operating hours are required for non-24/7 departments')
    }

    // Validate hours
    for (const hour of formData.value.hours) {
      if (hour.opens_at >= hour.closes_at) {
        throw new Error('Opening time must be before closing time')
      }
      if (hour.porters_required < 1) {
        throw new Error('At least 1 porter is required for each time period')
      }
    }

    // Convert times to include seconds for backend
    const submitData: DepartmentFormData = {
      ...formData.value,
      hours: formData.value.hours.map(h => ({
        ...h,
        opens_at: h.opens_at + ':00',
        closes_at: h.closes_at + ':00'
      }))
    }

    await emit('save', submitData)
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to save department'
  } finally {
    loading.value = false
  }
}

function handleClose() {
  emit('close')
}

// Watch for department changes
watch(() => props.department, initializeForm, { immediate: true })
</script>

<template>
  <div class="modal-overlay" @click.self="handleClose">
    <div class="modal">
      <div class="modal-header">
        <h2 class="modal-title">{{ modalTitle }}</h2>
        <button @click="handleClose" class="btn btn-sm btn-secondary">
          ✕
        </button>
      </div>

      <form @submit.prevent="handleSubmit" class="modal-body">
        <!-- Error Display -->
        <div v-if="error" class="alert alert-error mb-4">
          {{ error }}
        </div>

        <!-- Department Name -->
        <div class="form-group">
          <label class="form-label">Name</label>
          <input
            v-model="formData.name"
            type="text"
            class="form-input"
            placeholder="e.g., Emergency Department"
            required
          />
        </div>

        <!-- Operation Type -->
        <div class="form-group">
          <label class="form-label">Operation Type</label>
          <div class="radio-group">
            <label class="radio-option">
              <input
                v-model="formData.is_24_7"
                type="radio"
                :value="true"
                @change="toggleOperationType"
              />
              <span>24/7 Operation</span>
            </label>
            <label class="radio-option">
              <input
                v-model="formData.is_24_7"
                type="radio"
                :value="false"
                @change="toggleOperationType"
              />
              <span>Set Days and Times</span>
            </label>
          </div>
        </div>

        <!-- Default Porters Required (for 24/7) -->
        <div v-if="formData.is_24_7" class="form-group">
          <label class="form-label">Porters Required</label>
          <input
            v-model.number="formData.porters_required"
            type="number"
            class="form-input"
            min="1"
            required
          />
        </div>

        <!-- Operating Hours (for scheduled departments) -->
        <div v-if="!formData.is_24_7" class="operating-hours-section">
          <div class="section-header">
            <h3 class="section-title">Operating Hours</h3>
            <button
              type="button"
              @click="addHour"
              class="btn btn-sm btn-secondary"
            >
              Add Hours
            </button>
          </div>

          <div v-if="formData.hours.length === 0" class="empty-hours">
            <p>No operating hours set. Click "Add Hours" to get started.</p>
          </div>

          <div v-else class="hours-list">
            <div
              v-for="(hour, index) in formData.hours"
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
                  <label class="field-label">Opens</label>
                  <input
                    v-model="hour.opens_at"
                    type="time"
                    class="form-input"
                    required
                  />
                </div>

                <div class="field-group">
                  <label class="field-label">Closes</label>
                  <input
                    v-model="hour.closes_at"
                    type="time"
                    class="form-input"
                    required
                  />
                </div>

                <div class="field-group">
                  <label class="field-label">Porters</label>
                  <input
                    v-model.number="hour.porters_required"
                    type="number"
                    class="form-input"
                    min="1"
                    required
                  />
                </div>

                <div class="field-group">
                  <button
                    type="button"
                    @click="removeHour(index)"
                    class="btn btn-sm btn-secondary"
                    :disabled="formData.hours.length === 1"
                  >
                    Remove
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </form>

      <div class="modal-footer">
        <button
          type="button"
          @click="handleClose"
          class="btn btn-secondary"
          :disabled="loading"
        >
          Cancel
        </button>
        <button
          @click="handleSubmit"
          class="btn btn-primary"
          :disabled="loading"
        >
          {{ loading ? 'Saving...' : (isEditing ? 'Update' : 'Create') }}
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.modal {
  width: 90vw;
  max-width: 800px;
}

.radio-group {
  display: flex;
  gap: var(--space-4);
}

.radio-option {
  display: flex;
  align-items: center;
  gap: var(--space-2);
  cursor: pointer;
}

.radio-option input[type="radio"] {
  margin: 0;
}

.operating-hours-section {
  margin-top: var(--space-6);
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
  background-color: var(--color-neutral-50);
  border-radius: var(--radius-md);
}

.hours-list {
  display: flex;
  flex-direction: column;
  gap: var(--space-4);
}

.hour-item {
  padding: var(--space-4);
  border: 1px solid var(--color-neutral-200);
  border-radius: var(--radius-md);
  background-color: var(--color-neutral-50);
}

.hour-fields {
  display: grid;
  grid-template-columns: 2fr 1fr 1fr 1fr auto;
  gap: var(--space-3);
  align-items: end;
}

@container (max-width: 768px) {
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

.form-select,
.form-input {
  font-size: var(--font-size-sm);
}
</style>
