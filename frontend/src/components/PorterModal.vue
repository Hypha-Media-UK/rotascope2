<template>
  <div class="modal-overlay" @click.self="$emit('close')">
    <div class="modal">
      <div class="modal-header">
        <h2 class="modal-title">{{ isEditing ? 'Edit Porter' : 'Create Porter' }}</h2>
        <button @click="$emit('close')" class="btn btn-sm btn-secondary">✕</button>
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
.modal {
  width: 90%;
  max-width: 500px;
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
}

.form-checkbox {
  width: auto;
}
</style>
