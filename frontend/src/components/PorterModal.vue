<template>
  <div class="modal-overlay" @click.self="$emit('close')">
    <div class="modal-content">
      <div class="modal-header">
        <h2>{{ isEditing ? 'Edit Porter' : 'Create Porter' }}</h2>
        <button @click="$emit('close')" class="btn-close">&times;</button>
      </div>

      <form @submit.prevent="handleSubmit" class="modal-body">
        <div v-if="error" class="alert alert-error">
          {{ error }}
        </div>

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
              <option value="SENIOR_PORTER">Senior Porter</option>
              <option value="SUPERVISOR">Supervisor</option>
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

        <div class="modal-actions">
          <button type="button" @click="$emit('close')" class="btn btn-secondary">
            Cancel
          </button>
          <button type="submit" :disabled="loading" class="btn btn-primary">
            {{ loading ? 'Saving...' : (isEditing ? 'Update Porter' : 'Create Porter') }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import type { Porter, PorterFormData } from '@/types'

interface Props {
  porter?: Porter | null
}

interface Emits {
  (e: 'save', data: PorterFormData): void
  (e: 'close'): void
}

const props = defineProps<Props>()
const emit = defineEmits<Emits>()

const loading = ref(false)
const error = ref<string | null>(null)

const formData = ref<PorterFormData>({
  name: '',
  email: '',
  porter_type: 'PORTER',
  contracted_hours_type: 'SHIFT',
  weekly_contracted_hours: 37.5,
  is_active: true
})

const isEditing = computed(() => props.porter !== null)

function initializeForm() {
  if (props.porter) {
    formData.value = {
      name: props.porter.name,
      email: props.porter.email || '',
      porter_type: props.porter.porter_type,
      contracted_hours_type: props.porter.contracted_hours_type,
      weekly_contracted_hours: props.porter.weekly_contracted_hours,
      is_active: Boolean(props.porter.is_active)
    }
  } else {
    formData.value = {
      name: '',
      email: '',
      porter_type: 'PORTER',
      contracted_hours_type: 'SHIFT',
      weekly_contracted_hours: 37.5,
      is_active: true
    }
  }
}

watch(() => props.porter, () => {
  initializeForm()
}, { immediate: true })

async function handleSubmit() {
  error.value = null
  loading.value = true

  try {
    await emit('save', formData.value)
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to save porter'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-content {
  background: white;
  border-radius: var(--border-radius);
  box-shadow: var(--shadow-lg);
  width: 90%;
  max-width: 600px;
  max-height: 90vh;
  overflow-y: auto;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--space-6);
  border-bottom: 1px solid var(--color-border);
}

.modal-header h2 {
  margin: 0;
  color: var(--color-text-primary);
}

.btn-close {
  background: none;
  border: none;
  font-size: 1.5rem;
  cursor: pointer;
  color: var(--color-text-secondary);
  padding: 0;
  width: 2rem;
  height: 2rem;
  display: flex;
  align-items: center;
  justify-content: center;
}

.btn-close:hover {
  color: var(--color-text-primary);
}

.modal-body {
  padding: var(--space-6);
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--space-4);
}

.form-group {
  margin-bottom: var(--space-4);
}

.form-group label {
  display: block;
  margin-bottom: var(--space-2);
  font-weight: 500;
  color: var(--color-text-primary);
}

.form-input {
  width: 100%;
  padding: var(--space-3);
  border: 1px solid var(--color-border);
  border-radius: var(--border-radius);
  font-size: 1rem;
}

.form-input:focus {
  outline: none;
  border-color: var(--color-primary);
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
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

.modal-actions {
  display: flex;
  gap: var(--space-3);
  justify-content: flex-end;
  margin-top: var(--space-6);
  padding-top: var(--space-4);
  border-top: 1px solid var(--color-border);
}

.alert {
  padding: var(--space-3);
  border-radius: var(--border-radius);
  margin-bottom: var(--space-4);
}

.alert-error {
  background: #fef2f2;
  color: #dc2626;
  border: 1px solid #fecaca;
}

.btn {
  padding: var(--space-3) var(--space-4);
  border: none;
  border-radius: var(--border-radius);
  cursor: pointer;
  font-weight: 500;
  transition: all 0.2s;
}

.btn-primary {
  background: var(--color-primary);
  color: white;
}

.btn-primary:hover:not(:disabled) {
  background: var(--color-primary-dark);
}

.btn-primary:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.btn-secondary {
  background: var(--color-background-secondary);
  color: var(--color-text-primary);
  border: 1px solid var(--color-border);
}

.btn-secondary:hover {
  background: var(--color-background-tertiary);
}
</style>
