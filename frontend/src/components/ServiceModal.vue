<template>
  <div class="modal-overlay" @click.self="$emit('close')">
    <div class="modal-content">
      <div class="modal-header">
        <h2>{{ isEditing ? 'Edit Service' : 'Create Service' }}</h2>
        <button @click="$emit('close')" class="btn-close">&times;</button>
      </div>

      <form @submit.prevent="handleSubmit" class="modal-body">
        <div v-if="error" class="alert alert-error">
          {{ error }}
        </div>

        <div class="form-group">
          <label for="service-name">Service Name *</label>
          <input
            id="service-name"
            v-model="formData.name"
            type="text"
            required
            placeholder="Enter service name"
            class="form-input"
          />
        </div>

        <div class="form-group">
          <label for="service-code">Service Code</label>
          <input
            id="service-code"
            v-model="formData.code"
            type="text"
            placeholder="Auto-generated from name"
            class="form-input"
          />
        </div>

        <div class="form-group">
          <label class="checkbox-label">
            <input
              v-model="formData.is_24_7"
              type="checkbox"
              class="form-checkbox"
            />
            24/7 Operation
          </label>
        </div>

        <div class="porter-requirements">
          <h3>Porter Requirements</h3>
          <div class="requirements-grid">
            <div class="form-group">
              <label for="porters-day">Day Shift Porters *</label>
              <input
                id="porters-day"
                v-model.number="formData.porters_required_day"
                type="number"
                min="1"
                required
                class="form-input"
              />
            </div>

            <div class="form-group">
              <label for="porters-night">Night Shift Porters *</label>
              <input
                id="porters-night"
                v-model.number="formData.porters_required_night"
                type="number"
                min="1"
                required
                class="form-input"
              />
            </div>
          </div>
        </div>

        <div class="modal-actions">
          <button type="button" @click="$emit('close')" class="btn btn-secondary">
            Cancel
          </button>
          <button type="submit" :disabled="loading" class="btn btn-primary">
            {{ loading ? 'Saving...' : (isEditing ? 'Update Service' : 'Create Service') }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import type { Service, ServiceFormData } from '@/types'

interface Props {
  service?: Service | null
}

interface Emits {
  (e: 'save', data: ServiceFormData): void
  (e: 'close'): void
}

const props = defineProps<Props>()
const emit = defineEmits<Emits>()

const loading = ref(false)
const error = ref<string | null>(null)

const formData = ref<ServiceFormData>({
  name: '',
  code: '',
  is_24_7: false,
  porters_required_day: 1,
  porters_required_night: 1
})

const isEditing = computed(() => props.service !== null)

function initializeForm() {
  if (props.service) {
    formData.value = {
      name: props.service.name,
      code: props.service.code || '',
      is_24_7: Boolean(props.service.is_24_7),
      porters_required_day: props.service.porters_required_day || 1,
      porters_required_night: props.service.porters_required_night || 1
    }
  } else {
    formData.value = {
      name: '',
      code: '',
      is_24_7: false,
      porters_required_day: 1,
      porters_required_night: 1
    }
  }
}

// Auto-generate code from name
watch(() => formData.value.name, (newName) => {
  if (!isEditing.value && newName) {
    formData.value.code = newName.toUpperCase().replace(/\s+/g, '').substring(0, 10)
  }
})

watch(() => props.service, () => {
  initializeForm()
}, { immediate: true })

async function handleSubmit() {
  error.value = null
  loading.value = true

  try {
    await emit('save', formData.value)
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to save service'
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
  max-width: 500px;
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

.porter-requirements {
  margin: var(--space-6) 0;
  padding: var(--space-4);
  background: var(--color-background-secondary);
  border-radius: var(--border-radius);
}

.porter-requirements h3 {
  margin: 0 0 var(--space-4) 0;
  color: var(--color-text-primary);
}

.requirements-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--space-4);
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
