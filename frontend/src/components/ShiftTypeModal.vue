<template>
  <div class="modal-overlay" @click.self="$emit('close')">
    <div class="modal">
      <div class="modal-header">
        <h2 class="modal-title">{{ isEditing ? 'Edit Shift Type' : 'Create Shift Type' }}</h2>
        <button @click="$emit('close')" class="btn btn-sm btn-secondary">✕</button>
      </div>

      <form @submit.prevent="handleSubmit" class="modal-body">
        <div v-if="error" class="alert alert-error">
          {{ error }}
        </div>

        <div class="form-group">
          <label for="shift-type-name">Shift Type Name *</label>
          <input
            id="shift-type-name"
            v-model="formData.name"
            type="text"
            required
            placeholder="e.g., Day Shift A, Night Shift B"
            class="form-input"
          />
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
            <label>Display Type *</label>
            <div class="radio-group">
              <label class="radio-label">
                <input
                  v-model="formData.display_type"
                  type="radio"
                  value="DAY"
                  class="form-radio"
                />
                <span>Day Shift</span>
              </label>
              <label class="radio-label">
                <input
                  v-model="formData.display_type"
                  type="radio"
                  value="NIGHT"
                  class="form-radio"
                />
                <span>Night Shift</span>
              </label>
            </div>
          </div>

          <div class="form-group">
            <label for="color">Color (Optional)</label>
            <div class="color-input-group">
              <input
                id="color"
                v-model="formData.color"
                type="color"
                class="form-color"
              />
              <input
                v-model="formData.color"
                type="text"
                placeholder="#4CAF50"
                pattern="^#[0-9A-Fa-f]{6}$"
                class="form-input color-text"
              />
            </div>
            <small class="form-help">Used for visual differentiation in the UI</small>
          </div>
        </div>

        <div class="modal-actions">
          <button type="button" @click="$emit('close')" class="btn btn-secondary">
            Cancel
          </button>
          <button type="submit" :disabled="loading" class="btn btn-primary">
            {{ loading ? 'Saving...' : (isEditing ? 'Update Shift Type' : 'Create Shift Type') }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import type { ShiftType, ShiftTypeFormData } from '@/types'

interface Props {
  shiftType?: ShiftType | null
}

interface Emits {
  (e: 'save', data: ShiftTypeFormData): void
  (e: 'close'): void
}

const props = defineProps<Props>()
const emit = defineEmits<Emits>()

const loading = ref(false)
const error = ref<string | null>(null)

const formData = ref<ShiftTypeFormData>({
  name: '',
  starts_at: '08:00',
  ends_at: '20:00',
  display_type: 'DAY',
  color: '#4CAF50'
})

const isEditing = computed(() => props.shiftType !== null)

function initializeForm() {
  if (props.shiftType) {
    formData.value = {
      name: props.shiftType.name,
      starts_at: props.shiftType.starts_at.substring(0, 5), // Remove seconds
      ends_at: props.shiftType.ends_at.substring(0, 5), // Remove seconds
      display_type: props.shiftType.display_type,
      color: props.shiftType.color || '#4CAF50'
    }
  } else {
    formData.value = {
      name: '',
      starts_at: '08:00',
      ends_at: '20:00',
      display_type: 'DAY',
      color: '#4CAF50'
    }
  }
}

// Auto-set color based on display type
watch(() => formData.value.display_type, (newType) => {
  if (!isEditing.value) {
    formData.value.color = newType === 'DAY' ? '#4CAF50' : '#3F51B5'
  }
})

watch(() => props.shiftType, () => {
  initializeForm()
}, { immediate: true })

async function handleSubmit() {
  error.value = null
  loading.value = true

  try {
    // Validate times
    if (formData.value.starts_at === formData.value.ends_at) {
      throw new Error('Start time and end time cannot be the same')
    }

    // Convert times to include seconds for backend
    const submitData: ShiftTypeFormData = {
      ...formData.value,
      starts_at: formData.value.starts_at + ':00',
      ends_at: formData.value.ends_at + ':00'
    }

    await emit('save', submitData)
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to save shift type'
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

.radio-group {
  display: flex;
  gap: var(--space-4);
  margin-top: var(--space-2);
}

.radio-label {
  display: flex;
  align-items: center;
  gap: var(--space-2);
  cursor: pointer;
  font-weight: normal;
}

.form-radio {
  width: auto;
  margin: 0;
}

.color-input-group {
  display: flex;
  gap: var(--space-2);
  align-items: center;
}

.form-color {
  width: 50px;
  height: 40px;
  border: 1px solid var(--color-border);
  border-radius: var(--radius-sm);
  cursor: pointer;
  padding: 0;
}

.color-text {
  flex: 1;
  font-family: monospace;
}

.form-help {
  display: block;
  margin-top: var(--space-1);
  font-size: 0.875rem;
  color: var(--color-text-secondary);
}
</style>
