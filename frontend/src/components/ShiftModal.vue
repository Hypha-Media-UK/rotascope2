<template>
  <div class="modal-overlay" @click.self="$emit('close')">
    <div class="modal">
      <div class="modal-header">
        <h2 class="modal-title">{{ isEditing ? 'Edit Shift' : 'Create Shift' }}</h2>
        <button @click="$emit('close')" class="btn btn-sm btn-secondary">✕</button>
      </div>

      <form @submit.prevent="handleSubmit" class="modal-body">
        <div v-if="error" class="alert alert-error">
          {{ error }}
        </div>

        <div class="form-group">
          <label for="shift-name">Shift Name *</label>
          <input
            id="shift-name"
            v-model="formData.name"
            type="text"
            required
            placeholder="Enter shift name"
            class="form-input"
          />
        </div>

        <div class="form-group">
          <label for="shift-type">Shift Type</label>
          <select
            id="shift-type"
            v-model="formData.shift_type_id"
            class="form-input"
          >
            <option value="">No shift type (custom shift)</option>
            <option v-for="shiftType in shiftTypes" :key="shiftType.id" :value="shiftType.id">
              {{ shiftType.name }} ({{ shiftType.display_type }})
            </option>
          </select>
          <small class="form-help">Optional: Associate this shift with a shift type for UI display</small>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label for="starts-at">Start Time *</label>
            <input
              id="starts-at"
              v-model="formData.starts_at"
              type="time"
              required
              class="form-input"
            />
          </div>

          <div class="form-group">
            <label for="ends-at">End Time *</label>
            <input
              id="ends-at"
              v-model="formData.ends_at"
              type="time"
              required
              class="form-input"
            />
          </div>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label for="days-on">Days On *</label>
            <input
              id="days-on"
              v-model.number="formData.days_on"
              type="number"
              min="1"
              max="14"
              required
              placeholder="e.g., 4"
              class="form-input"
            />
          </div>

          <div class="form-group">
            <label for="days-off">Days Off *</label>
            <input
              id="days-off"
              v-model.number="formData.days_off"
              type="number"
              min="1"
              max="14"
              required
              placeholder="e.g., 4"
              class="form-input"
            />
          </div>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label for="shift-offset">Shift Offset</label>
            <input
              id="shift-offset"
              v-model.number="formData.shift_offset"
              type="number"
              min="0"
              max="13"
              placeholder="0"
              class="form-input"
            />
          </div>
        </div>

        <div class="form-group">
          <label for="ground-zero">Ground Zero Date *</label>
          <input
            id="ground-zero"
            v-model="formData.ground_zero_date"
            type="date"
            required
            class="form-input"
          />
          <small class="form-help">Reference date for cycle calculations</small>
        </div>



        <div class="form-group">
          <label class="checkbox-label">
            <input
              v-model="formData.is_active"
              type="checkbox"
              class="form-checkbox"
            />
            Active Shift
          </label>
        </div>

      </form>

      <div class="modal-footer">
        <button type="button" @click="$emit('close')" class="btn btn-secondary" :disabled="loading">
          Cancel
        </button>
        <button @click="handleSubmit" class="btn btn-primary" :disabled="loading">
          {{ loading ? 'Saving...' : (isEditing ? 'Update Shift' : 'Create Shift') }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted } from 'vue'
import type { Shift, ShiftFormData, ShiftType } from '@/types'
import { shiftTypeApi } from '@/services/api'

interface Props {
  shift?: Shift | null
}

interface Emits {
  (e: 'save', data: ShiftFormData): void
  (e: 'close'): void
}

const props = defineProps<Props>()
const emit = defineEmits<Emits>()

const loading = ref(false)
const error = ref<string | null>(null)
const shiftTypes = ref<ShiftType[]>([])
const loadingShiftTypes = ref(false)

const formData = ref<ShiftFormData>({
  name: '',
  shift_type_id: undefined,
  starts_at: '08:00',
  ends_at: '20:00',
  days_on: 4,
  days_off: 4,
  shift_offset: 0,
  ground_zero_date: new Date().toISOString().split('T')[0],
  is_active: true
})

const isEditing = computed(() => props.shift !== null)

function initializeForm() {
  if (props.shift) {
    formData.value = {
      name: props.shift.name,
      shift_type_id: props.shift.shift_type_id,
      starts_at: props.shift.starts_at.substring(0, 5), // Remove seconds
      ends_at: props.shift.ends_at.substring(0, 5), // Remove seconds
      days_on: props.shift.days_on,
      days_off: props.shift.days_off,
      shift_offset: props.shift.shift_offset,
      ground_zero_date: props.shift.ground_zero_date.split('T')[0],
      is_active: Boolean(props.shift.is_active)
    }
  } else {
    formData.value = {
      name: '',
      shift_type_id: undefined,
      starts_at: '08:00',
      ends_at: '20:00',
      days_on: 4,
      days_off: 4,
      shift_offset: 0,
      ground_zero_date: new Date().toISOString().split('T')[0],
      is_active: true
    }
  }
}

// Load shift types
async function loadShiftTypes() {
  try {
    loadingShiftTypes.value = true
    shiftTypes.value = await shiftTypeApi.getAll()
  } catch (err) {
    console.error('Error loading shift types:', err)
  } finally {
    loadingShiftTypes.value = false
  }
}

watch(() => props.shift, () => {
  initializeForm()
}, { immediate: true })

onMounted(() => {
  loadShiftTypes()
})

async function handleSubmit() {
  error.value = null
  loading.value = true

  try {
    // Convert times to include seconds for backend
    const submitData: ShiftFormData = {
      ...formData.value,
      starts_at: formData.value.starts_at + ':00',
      ends_at: formData.value.ends_at + ':00'
    }

    await emit('save', submitData)
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to save shift'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.modal {
  width: 90%;
  max-width: 600px;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--space-4);
}

.form-help {
  display: block;
  margin-top: var(--space-1);
  font-size: 0.875rem;
  color: var(--color-text-secondary);
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
