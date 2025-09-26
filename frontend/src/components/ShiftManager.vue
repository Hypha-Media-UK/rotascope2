<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { shiftApi } from '@/services/api'
import type { Shift } from '@/types'

// State
const shifts = ref<Shift[]>([])
const loading = ref(true)
const error = ref<string | null>(null)

// Methods
async function loadShifts() {
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

function addShift() {
  // TODO: Implement shift creation in Phase 4
  alert('Add new shift functionality will be implemented in Phase 4: Business Logic Implementation.')
}

function editShift(shift: Shift) {
  // TODO: Implement shift editing in Phase 4
  alert(`Edit shift: ${shift.name}\n\nThis functionality will be implemented in Phase 4: Business Logic Implementation.`)
}

function deleteShift(shift: Shift) {
  // TODO: Implement shift deletion in Phase 4
  if (confirm(`Are you sure you want to delete shift ${shift.name}?\n\nThis functionality will be implemented in Phase 4: Business Logic Implementation.`)) {
    alert('Shift deletion will be implemented in Phase 4.')
  }
}

// Lifecycle
onMounted(() => {
  loadShifts()
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
      <button class="btn btn-primary" @click="addShift">
        Add Shift
      </button>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="loading-state">
      <div class="loading-spinner"></div>
      <p>Loading shifts...</p>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="error-state">
      <p class="error-message">{{ error }}</p>
      <button @click="loadShifts" class="btn btn-secondary">
        Try Again
      </button>
    </div>

    <!-- Shifts Grid -->
    <div v-else class="shifts-grid">
      <div v-for="shift in shifts" :key="shift.id" class="shift-card">
        <div class="shift-header">
          <div class="shift-info">
            <h4 class="shift-name">{{ shift.name }}</h4>
            <span class="shift-code">{{ shift.code }}</span>
          </div>
          <div class="shift-status">
            <span :class="['status-badge', shift.is_active ? 'status-active' : 'status-inactive']">
              {{ shift.is_active ? 'Active' : 'Inactive' }}
            </span>
          </div>
        </div>

        <div class="shift-details">
          <div class="time-info">
            <div class="time-row">
              <span class="time-label">Start Time:</span>
              <span class="time-value">{{ formatTime(shift.start_time) }}</span>
            </div>
            <div class="time-row">
              <span class="time-label">End Time:</span>
              <span class="time-value">{{ formatTime(shift.end_time) }}</span>
            </div>
          </div>

          <div class="cycle-info">
            <div class="detail-row">
              <span class="detail-label">Cycle Length:</span>
              <span class="detail-value">{{ shift.cycle_length_weeks }} weeks</span>
            </div>
            <div class="detail-row">
              <span class="detail-label">Ground Zero:</span>
              <span class="detail-value">{{ new Date(shift.ground_zero_date).toLocaleDateString() }}</span>
            </div>
            <div class="detail-row">
              <span class="detail-label">Offset:</span>
              <span class="detail-value">{{ shift.cycle_offset_weeks }} weeks</span>
            </div>
          </div>
        </div>

        <div class="shift-actions">
          <button class="btn btn-secondary btn-sm" @click="editShift(shift)">Edit</button>
          <button class="btn btn-danger btn-sm" @click="deleteShift(shift)">Delete</button>
        </div>
      </div>
    </div>

    <!-- Empty State -->
    <div v-if="!loading && !error && shifts.length === 0" class="empty-state">
      <p>No shifts found</p>
    </div>
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
.error-state,
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

.error-message {
  color: var(--color-danger);
  margin-bottom: var(--space-4);
}

.shifts-grid {
  display: grid;
  gap: var(--space-6);
  grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
}

.shift-card {
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  padding: var(--space-6);
  transition: all 0.2s ease;
}

.shift-card:hover {
  border-color: var(--color-primary);
  box-shadow: var(--shadow-md);
}

.shift-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  margin-bottom: var(--space-4);
  gap: var(--space-4);
}

.shift-info {
  flex: 1;
}

.shift-name {
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-semibold);
  color: var(--color-text-primary);
  margin: 0 0 var(--space-1) 0;
}

.shift-code {
  display: inline-block;
  background: var(--color-background-secondary);
  color: var(--color-text-secondary);
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
  padding: var(--space-1) var(--space-2);
  border-radius: var(--radius-sm);
  font-family: var(--font-mono);
}

.shift-details {
  display: flex;
  flex-direction: column;
  gap: var(--space-4);
  margin-bottom: var(--space-4);
}

.time-info {
  padding: var(--space-3);
  background: var(--color-background-secondary);
  border-radius: var(--radius-md);
}

.time-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.time-row:not(:last-child) {
  margin-bottom: var(--space-2);
}

.time-label {
  font-weight: var(--font-weight-medium);
  color: var(--color-text-secondary);
}

.time-value {
  font-family: var(--font-mono);
  font-weight: var(--font-weight-semibold);
  color: var(--color-text-primary);
}

.cycle-info {
  display: flex;
  flex-direction: column;
  gap: var(--space-2);
}

.detail-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.detail-label {
  font-weight: var(--font-weight-medium);
  color: var(--color-text-secondary);
}

.detail-value {
  color: var(--color-text-primary);
}

.shift-actions {
  display: flex;
  gap: var(--space-2);
  justify-content: flex-end;
}

.status-badge {
  display: inline-block;
  padding: var(--space-1) var(--space-2);
  border-radius: var(--radius-full);
  font-size: var(--font-size-xs);
  font-weight: var(--font-weight-medium);
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.status-active {
  background: var(--color-success-light);
  color: var(--color-success-dark);
}

.status-inactive {
  background: var(--color-warning-light);
  color: var(--color-warning-dark);
}

@container (max-width: 768px) {
  .shifts-grid {
    grid-template-columns: 1fr;
  }

  .manager-header {
    flex-direction: column;
    align-items: flex-start;
    gap: var(--space-4);
  }
}
</style>
