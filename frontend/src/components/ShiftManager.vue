<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { shiftApi, shiftTypeApi } from '@/services/api'
import type { Shift, ShiftFormData, ShiftType, ShiftTypeFormData } from '@/types'
import CrudCard from './CrudCard.vue'
import ShiftModal from './ShiftModal.vue'
import ShiftTypeModal from './ShiftTypeModal.vue'

// State
const shifts = ref<Shift[]>([])
const shiftTypes = ref<ShiftType[]>([])
const loading = ref(true)
const error = ref<string | null>(null)
const showModal = ref(false)
const showShiftTypeModal = ref(false)
const editingShift = ref<Shift | null>(null)
const editingShiftType = ref<ShiftType | null>(null)

// Computed
const isEditing = computed(() => editingShift.value !== null)
const isEditingShiftType = computed(() => editingShiftType.value !== null)

// Methods
async function loadData() {
  try {
    loading.value = true
    error.value = null
    const [shiftsData, shiftTypesData] = await Promise.all([
      shiftApi.getAll(),
      shiftTypeApi.getAll()
    ])
    shifts.value = shiftsData
    shiftTypes.value = shiftTypesData
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to load data'
    console.error('Error loading data:', err)
  } finally {
    loading.value = false
  }
}

function formatTime(time: string): string {
  return new Date(`2000-01-01T${time}`).toLocaleTimeString('en-US', {
    hour: '2-digit',
    minute: '2-digit',
    hour12: false
  })
}

// Modal methods
function openCreateModal() {
  editingShift.value = null
  showModal.value = true
}

function openEditModal(shift: Shift) {
  editingShift.value = shift
  showModal.value = true
}

function openCreateShiftTypeModal() {
  editingShiftType.value = null
  showShiftTypeModal.value = true
}

function openEditShiftTypeModal(shiftType: ShiftType) {
  editingShiftType.value = shiftType
  showShiftTypeModal.value = true
}

function closeModal() {
  showModal.value = false
  editingShift.value = null
}

function closeShiftTypeModal() {
  showShiftTypeModal.value = false
  editingShiftType.value = null
}

async function handleSave(formData: ShiftFormData) {
  try {
    if (isEditing.value && editingShift.value) {
      await shiftApi.update(editingShift.value.id, formData)
    } else {
      await shiftApi.create(formData)
    }

    await loadData()
    closeModal()
  } catch (err) {
    console.error('Error saving shift:', err)
    throw err // Let the modal handle the error display
  }
}

async function handleShiftTypeSave(formData: ShiftTypeFormData) {
  try {
    if (isEditingShiftType.value && editingShiftType.value) {
      await shiftTypeApi.update(editingShiftType.value.id, formData)
    } else {
      await shiftTypeApi.create(formData)
    }

    await loadData()
    closeShiftTypeModal()
  } catch (err) {
    console.error('Error saving shift type:', err)
    throw err // Let the modal handle the error display
  }
}

async function handleDelete(shift: Shift) {
  if (!confirm(`Are you sure you want to delete "${shift.name}"?`)) {
    return
  }

  try {
    await shiftApi.delete(shift.id)
    await loadData()
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to delete shift'
    console.error('Error deleting shift:', err)
  }
}

async function handleShiftTypeDelete(shiftType: ShiftType) {
  if (!confirm(`Are you sure you want to delete "${shiftType.name}"?`)) {
    return
  }

  try {
    await shiftTypeApi.delete(shiftType.id)
    await loadData()
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to delete shift type'
    console.error('Error deleting shift type:', err)
  }
}

function getShiftInfoItems(shift: Shift) {
  const items = [
    { label: 'Times', value: `${formatTime(shift.starts_at)} - ${formatTime(shift.ends_at)}` },
    { label: 'Pattern', value: `${shift.days_on} on, ${shift.days_off} off` },
    { label: 'Offset', value: `${shift.shift_offset} days` }
  ]

  // Add shift type info if available
  if (shift.shift_type_id) {
    const shiftType = shiftTypes.value.find(st => st.id === shift.shift_type_id)
    if (shiftType) {
      items.unshift({ label: 'Type', value: `${shiftType.name} (${shiftType.display_type})` })
    }
  } else {
    items.unshift({ label: 'Type', value: 'Custom Shift' })
  }

  return items
}

function getShiftTypeInfoItems(shiftType: ShiftType) {
  return [
    { label: 'Display Type', value: shiftType.display_type },
    { label: 'Times', value: `${formatTime(shiftType.starts_at)} - ${formatTime(shiftType.ends_at)}` },
    { label: 'Color', value: shiftType.color || 'None' }
  ]
}

// Lifecycle
onMounted(() => {
  loadData()
})
</script>

<template>
  <div class="shift-manager">
    <!-- Header -->
    <div class="manager-header">
      <div class="header-content">
        <h2 class="manager-title">Shifts</h2>
        <p class="manager-description">
          Manage shift patterns, cycles, and schedules
        </p>
      </div>
      <div class="header-actions">
        <button class="btn btn-secondary" @click="openCreateShiftTypeModal">
          Add Shift Type
        </button>
        <button class="btn btn-primary" @click="openCreateModal">
          Add Shift
        </button>
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="loading-state">
      <div class="loading-spinner"></div>
      <p>Loading shifts...</p>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="alert alert-error">
      <p>{{ error }}</p>
      <button @click="loadData" class="btn btn-sm btn-secondary">
        Try Again
      </button>
    </div>

    <!-- Content -->
    <div v-else class="manager-content">
      <!-- Shift Types Section -->
      <div class="section">
        <div class="section-header">
          <h3 class="section-title">Shift Types</h3>
          <p class="section-description">Define shift types for categorization and visual display</p>
        </div>

        <div v-if="shiftTypes.length === 0" class="empty-state-small">
          <p>No shift types defined. Create shift types to categorize your shifts.</p>
          <button @click="openCreateShiftTypeModal" class="btn btn-sm btn-secondary">
            Add Shift Type
          </button>
        </div>

        <div v-else class="shift-types-grid">
          <CrudCard
            v-for="shiftType in shiftTypes"
            :key="shiftType.id"
            :title="shiftType.name"
            :info-items="getShiftTypeInfoItems(shiftType)"
            :color="shiftType.color"
            @edit="openEditShiftTypeModal(shiftType)"
            @delete="handleShiftTypeDelete(shiftType)"
          />
        </div>
      </div>

      <!-- Shifts Section -->
      <div class="section">
        <div class="section-header">
          <h3 class="section-title">Shifts</h3>
          <p class="section-description">Manage shift patterns and schedules</p>
        </div>

        <div v-if="shifts.length === 0" class="empty-state-small">
          <p>No shifts created. Create your first shift pattern to get started.</p>
          <button @click="openCreateModal" class="btn btn-sm btn-primary">
            Add Shift
          </button>
        </div>

        <div v-else class="departments-grid">
          <CrudCard
            v-for="shift in shifts"
            :key="shift.id"
            :title="shift.name"
            :info-items="getShiftInfoItems(shift)"
            @edit="openEditModal(shift)"
            @delete="handleDelete(shift)"
          />
        </div>
      </div>
    </div>

    <!-- Shift Modal -->
    <ShiftModal
      v-if="showModal"
      :shift="editingShift"
      @save="handleSave"
      @close="closeModal"
    />

    <!-- Shift Type Modal -->
    <ShiftTypeModal
      v-if="showShiftTypeModal"
      :shift-type="editingShiftType"
      @save="handleShiftTypeSave"
      @close="closeShiftTypeModal"
    />

  </div>
</template>

<style scoped>
.shift-manager {
  container-type: inline-size;
}

.manager-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  margin-bottom: var(--space-8);
  gap: var(--space-6);
}

.header-content {
  flex: 1;
}

.manager-title {
  font-size: var(--font-size-2xl);
  font-weight: var(--font-weight-bold);
  color: var(--color-text-primary);
  margin: 0 0 var(--space-2) 0;
}

.manager-description {
  color: var(--color-text-secondary);
  margin: 0;
}

.header-actions {
  display: flex;
  gap: var(--space-3);
}

.manager-content {
  display: flex;
  flex-direction: column;
  gap: var(--space-8);
}

.section {
  display: flex;
  flex-direction: column;
  gap: var(--space-4);
}

.section-header {
  border-bottom: 1px solid var(--color-border);
  padding-bottom: var(--space-3);
}

.section-title {
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-semibold);
  color: var(--color-text-primary);
  margin: 0 0 var(--space-1) 0;
}

.section-description {
  color: var(--color-text-secondary);
  font-size: var(--font-size-sm);
  margin: 0;
}

.shift-types-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: var(--space-4);
}

.empty-state-small {
  padding: var(--space-6);
  text-align: center;
  background: var(--color-background-secondary);
  border-radius: var(--radius-md);
  border: 1px dashed var(--color-border);
}

.loading-state,
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: var(--space-12);
  text-align: center;
}

.loading-spinner {
  width: 32px;
  height: 32px;
  border: 3px solid var(--color-border);
  border-top: 3px solid var(--color-primary);
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: var(--space-4);
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.departments-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
  gap: var(--space-6);
}

@container (max-width: 768px) {
  .departments-grid {
    grid-template-columns: 1fr;
  }
}

.alert {
  padding: var(--space-4);
  border-radius: var(--border-radius);
  margin-bottom: var(--space-6);
}

.alert-error {
  background: #fef2f2;
  color: #dc2626;
  border: 1px solid #fecaca;
}

/* Removed old shift-specific styles - now using CrudCard component */



@container (max-width: 768px) {
  .manager-header {
    flex-direction: column;
    align-items: flex-start;
    gap: var(--space-4);
  }
}
</style>
