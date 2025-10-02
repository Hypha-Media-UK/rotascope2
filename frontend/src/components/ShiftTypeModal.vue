<template>
  <div class="modal-overlay" @click.self="$emit('close')">
    <div class="modal shift-types-modal">
      <div class="modal-header">
        <h2 class="modal-title">Manage Shift Types</h2>
        <button @click="$emit('close')" class="btn btn-sm btn-secondary">✕</button>
      </div>

      <div class="modal-body">
        <div v-if="error" class="alert alert-error">
          {{ error }}
        </div>

        <!-- Add New Shift Type Form -->
        <form @submit.prevent="handleSubmit" class="add-form">
          <div class="table-row add-row">
            <div class="cell name-cell">
              <input
                v-model="formData.name"
                type="text"
                class="form-input"
                placeholder="Shift Type Name"
                required
              />
            </div>
            <div class="cell time-cell">
              <input
                v-model="formData.starts_at"
                type="time"
                class="form-input"
                required
              />
            </div>
            <div class="cell time-cell">
              <input
                v-model="formData.ends_at"
                type="time"
                class="form-input"
                required
              />
            </div>
            <div class="cell radio-cell">
              <label class="radio-option">
                <input
                  v-model="formData.display_type"
                  type="radio"
                  value="DAY"
                  @change="onDisplayTypeChange"
                />
                <span class="radio-dot"></span>
              </label>
            </div>
            <div class="cell radio-cell">
              <label class="radio-option">
                <input
                  v-model="formData.display_type"
                  type="radio"
                  value="NIGHT"
                  @change="onDisplayTypeChange"
                />
                <span class="radio-dot"></span>
              </label>
            </div>
            <div class="cell color-cell">
              <input
                v-model="formData.color"
                type="color"
                class="color-picker"
              />
            </div>
            <div class="cell actions-cell">
              <button type="submit" class="btn btn-primary btn-sm" :disabled="loading">
                {{ loading ? 'Adding...' : 'Add' }}
              </button>
            </div>
          </div>
        </form>

        <!-- Table Header -->
        <div class="table-header">
          <div class="cell name-cell">Shift Type</div>
          <div class="cell time-cell">Starts</div>
          <div class="cell time-cell">Ends</div>
          <div class="cell radio-cell">Day</div>
          <div class="cell radio-cell">Night</div>
          <div class="cell color-cell">Color</div>
          <div class="cell actions-cell">Actions</div>
        </div>

        <!-- Shift Types List -->
        <div class="shift-types-list">
          <div v-if="shiftTypes.length === 0" class="empty-row">
            <div class="empty-message">No shift types defined</div>
          </div>

          <div
            v-for="shiftType in shiftTypes"
            :key="shiftType.id"
            class="table-row"
            :class="{ 'editing': editingId === shiftType.id }"
          >
            <template v-if="editingId === shiftType.id">
              <!-- Edit Mode -->
              <div class="cell name-cell">
                <input
                  v-model="editFormData.name"
                  type="text"
                  class="form-input"
                  required
                />
              </div>
              <div class="cell time-cell">
                <input
                  v-model="editFormData.starts_at"
                  type="time"
                  class="form-input"
                  required
                />
              </div>
              <div class="cell time-cell">
                <input
                  v-model="editFormData.ends_at"
                  type="time"
                  class="form-input"
                  required
                />
              </div>
              <div class="cell radio-cell">
                <label class="radio-option">
                  <input
                    v-model="editFormData.display_type"
                    type="radio"
                    value="DAY"
                  />
                  <span class="radio-dot"></span>
                </label>
              </div>
              <div class="cell radio-cell">
                <label class="radio-option">
                  <input
                    v-model="editFormData.display_type"
                    type="radio"
                    value="NIGHT"
                  />
                  <span class="radio-dot"></span>
                </label>
              </div>
              <div class="cell color-cell">
                <input
                  v-model="editFormData.color"
                  type="color"
                  class="color-picker"
                />
              </div>
              <div class="cell actions-cell">
                <button @click="saveEdit" class="btn btn-primary btn-xs">Save</button>
                <button @click="cancelEdit" class="btn btn-secondary btn-xs">Cancel</button>
              </div>
            </template>

            <template v-else>
              <!-- Display Mode -->
              <div class="cell name-cell">{{ shiftType.name }}</div>
              <div class="cell time-cell">{{ formatTime(shiftType.starts_at) }}</div>
              <div class="cell time-cell">{{ formatTime(shiftType.ends_at) }}</div>
              <div class="cell radio-cell">
                <span v-if="shiftType.display_type === 'DAY'" class="radio-dot active"></span>
              </div>
              <div class="cell radio-cell">
                <span v-if="shiftType.display_type === 'NIGHT'" class="radio-dot active"></span>
              </div>
              <div class="cell color-cell">
                <div
                  class="color-preview"
                  :style="{ backgroundColor: shiftType.color }"
                ></div>
              </div>
              <div class="cell actions-cell">
                <button @click="startEdit(shiftType)" class="btn btn-secondary btn-xs">Update</button>
                <button @click="deleteShiftType(shiftType)" class="btn btn-danger btn-xs">Delete</button>
              </div>
            </template>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import type { ShiftType, ShiftTypeFormData } from '../types'
import { shiftTypeApi } from '../services/api'

interface Props {
  shiftType?: ShiftType | null
}

const props = defineProps<Props>()
const emit = defineEmits<{
  save: [data: ShiftTypeFormData]
  close: []
}>()

// State
const loading = ref(false)
const error = ref<string | null>(null)
const shiftTypes = ref<ShiftType[]>([])
const editingId = ref<number | null>(null)

// Form data for adding new shift type
const formData = ref<ShiftTypeFormData>({
  name: '',
  starts_at: '08:00',
  ends_at: '20:00',
  display_type: 'DAY',
  color: '#4CAF50'
})

// Form data for editing existing shift type
const editFormData = ref<ShiftTypeFormData>({
  name: '',
  starts_at: '',
  ends_at: '',
  display_type: 'DAY',
  color: ''
})

// Computed
const isEditing = computed(() => props.shiftType !== null)

// Methods
async function loadShiftTypes() {
  try {
    shiftTypes.value = await shiftTypeApi.getAll()
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to load shift types'
  }
}

function formatTime(time: string): string {
  return time.substring(0, 5) // Convert HH:MM:SS to HH:MM
}

function onDisplayTypeChange() {
  // Auto-set color based on display type
  if (formData.value.display_type === 'DAY') {
    formData.value.color = '#4CAF50'
  } else {
    formData.value.color = '#3F51B5'
  }
}

async function handleSubmit() {
  try {
    loading.value = true
    error.value = null

    // Convert HH:MM to HH:MM:SS for backend
    const submitData = {
      ...formData.value,
      starts_at: formData.value.starts_at + ':00',
      ends_at: formData.value.ends_at + ':00'
    }

    await shiftTypeApi.create(submitData)

    // Reset form
    formData.value = {
      name: '',
      starts_at: '08:00',
      ends_at: '20:00',
      display_type: 'DAY',
      color: '#4CAF50'
    }

    // Reload shift types
    await loadShiftTypes()
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to create shift type'
  } finally {
    loading.value = false
  }
}

function startEdit(shiftType: ShiftType) {
  editingId.value = shiftType.id
  editFormData.value = {
    name: shiftType.name,
    starts_at: formatTime(shiftType.starts_at),
    ends_at: formatTime(shiftType.ends_at),
    display_type: shiftType.display_type,
    color: shiftType.color || '#4CAF50'
  }
}

function cancelEdit() {
  editingId.value = null
}

async function saveEdit() {
  if (!editingId.value) return

  try {
    loading.value = true
    error.value = null

    // Convert HH:MM to HH:MM:SS for backend
    const submitData = {
      ...editFormData.value,
      starts_at: editFormData.value.starts_at + ':00',
      ends_at: editFormData.value.ends_at + ':00'
    }

    await shiftTypeApi.update(editingId.value, submitData)
    editingId.value = null
    await loadShiftTypes()
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to update shift type'
  } finally {
    loading.value = false
  }
}

async function deleteShiftType(shiftType: ShiftType) {
  if (!confirm(`Are you sure you want to delete "${shiftType.name}"?`)) {
    return
  }

  try {
    await shiftTypeApi.delete(shiftType.id)
    await loadShiftTypes()
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to delete shift type'
  }
}

// Lifecycle
onMounted(() => {
  loadShiftTypes()
})
</script>

<style scoped>
.shift-types-modal {
  max-width: 900px;
  width: 90vw;
}

.modal-body {
  padding: var(--space-6);
}

.add-form {
  margin-bottom: var(--space-6);
}

.table-row {
  display: grid;
  grid-template-columns: 2fr 1fr 1fr 60px 60px 80px 140px;
  gap: var(--space-3);
  align-items: center;
  padding: var(--space-3);
  border-radius: var(--radius-md);
}

.add-row {
  background-color: var(--color-background-secondary);
  border: 1px dashed var(--color-border);
  margin-bottom: var(--space-4);
}

.table-header {
  display: grid;
  grid-template-columns: 2fr 1fr 1fr 60px 60px 80px 140px;
  gap: var(--space-3);
  padding: var(--space-3);
  font-weight: var(--font-weight-semibold);
  color: var(--color-text-secondary);
  font-size: var(--font-size-sm);
  text-transform: uppercase;
  letter-spacing: 0.05em;
  border-bottom: 2px solid var(--color-border);
  margin-bottom: var(--space-2);
}

.table-row:not(.add-row) {
  border: 1px solid var(--color-border);
  margin-bottom: var(--space-2);
  background-color: white;
  transition: all 0.2s ease;
}

.table-row:not(.add-row):hover {
  box-shadow: var(--shadow-sm);
}

.table-row.editing {
  background-color: var(--color-background-secondary);
  border-color: var(--color-primary);
}

.cell {
  display: flex;
  align-items: center;
}

.name-cell input {
  width: 100%;
}

.time-cell input {
  width: 100%;
}

.radio-cell {
  justify-content: center;
}

.radio-option {
  display: flex;
  align-items: center;
  cursor: pointer;
}

.radio-option input[type="radio"] {
  display: none;
}

.radio-dot {
  width: 16px;
  height: 16px;
  border: 2px solid var(--color-border);
  border-radius: 50%;
  background-color: white;
  transition: all 0.2s ease;
}

.radio-option input[type="radio"]:checked + .radio-dot,
.radio-dot.active {
  background-color: var(--color-primary);
  border-color: var(--color-primary);
}

.color-cell {
  justify-content: center;
}

.color-picker {
  width: 40px;
  height: 30px;
  border: 1px solid var(--color-border);
  border-radius: var(--radius-sm);
  cursor: pointer;
}

.color-preview {
  width: 40px;
  height: 30px;
  border: 1px solid var(--color-border);
  border-radius: var(--radius-sm);
}

.actions-cell {
  gap: var(--space-2);
}

.empty-row {
  grid-column: 1 / -1;
  text-align: center;
  padding: var(--space-8);
  color: var(--color-text-secondary);
  font-style: italic;
}

.btn-xs {
  padding: var(--space-1) var(--space-2);
  font-size: var(--font-size-xs);
}

.btn-danger {
  background-color: #dc2626;
  color: white;
  border: 1px solid #dc2626;
  transition: all 0.2s ease;
}

.btn-danger:hover {
  background-color: #b91c1c;
  border-color: #b91c1c;
  transform: none;
}
</style>
