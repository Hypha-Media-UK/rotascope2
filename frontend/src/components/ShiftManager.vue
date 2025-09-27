<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { shiftApi } from '@/services/api'
import type { Shift, ShiftFormData } from '@/types'
import CrudCard from './CrudCard.vue'
import ShiftModal from './ShiftModal.vue'

// State
const shifts = ref<Shift[]>([])
const loading = ref(true)
const error = ref<string | null>(null)
const showModal = ref(false)
const editingShift = ref<Shift | null>(null)

// Computed
const isEditing = computed(() => editingShift.value !== null)

// Methods
async function loadData() {
  try {
    loading.value = true
    error.value = null
    shifts.value = await shiftApi.getAll()
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to load shifts'
    console.error('Error loading shifts:', err)
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

function closeModal() {
  showModal.value = false
  editingShift.value = null
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

function getShiftInfoItems(shift: Shift) {
  return [
    { label: 'Type', value: `${shift.shift_type} (${shift.shift_identifier})` },
    { label: 'Times', value: `${formatTime(shift.starts_at)} - ${formatTime(shift.ends_at)}` },
    { label: 'Pattern', value: `${shift.days_on} on, ${shift.days_off} off` },
    { label: 'Offset', value: `${shift.shift_offset} days` }
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
      <button class="btn btn-primary" @click="openCreateModal">
        Add Shift
      </button>
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

    <!-- Empty State -->
    <div v-else-if="shifts.length === 0" class="empty-state">
      <h3>No Shifts</h3>
      <p>Create your first shift pattern to get started.</p>
      <button @click="openCreateModal" class="btn btn-primary">
        Add Shift
      </button>
    </div>

    <!-- Shifts Grid -->
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

    <!-- Shift Modal -->
    <ShiftModal
      v-if="showModal"
      :shift="editingShift"
      @save="handleSave"
      @close="closeModal"
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
