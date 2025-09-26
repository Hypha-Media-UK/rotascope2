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
          Create and manage shift patterns and cycles
        </p>
      </div>
      
      <button class="btn btn-primary" disabled>
        Add Shift (Coming Soon)
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
      <button @click="loadShifts" class="btn btn-sm btn-secondary">
        Try Again
      </button>
    </div>

    <!-- Shifts List -->
    <div v-else class="shifts-list">
      <div v-if="shifts.length === 0" class="empty-state">
        <h3>No Shifts</h3>
        <p>Shift management will be available soon.</p>
      </div>

      <div v-else class="shifts-grid">
        <div
          v-for="shift in shifts"
          :key="shift.id"
          class="shift-card"
        >
          <div class="card-header">
            <h3 class="shift-name">{{ shift.name }}</h3>
            <div class="shift-badges">
              <span class="shift-type">{{ shift.shift_type }}</span>
              <span class="shift-ident">{{ shift.shift_ident }}</span>
            </div>
          </div>

          <div class="card-body">
            <div class="shift-info">
              <div class="info-item">
                <span class="info-label">Hours:</span>
                <span class="info-value">
                  {{ shift.starts_at.slice(0, 5) }} - {{ shift.ends_at.slice(0, 5) }}
                </span>
              </div>
              
              <div class="info-item">
                <span class="info-label">Cycle:</span>
                <span class="info-value">{{ shift.days_on }} on, {{ shift.days_off }} off</span>
              </div>
              
              <div class="info-item">
                <span class="info-label">Offset:</span>
                <span class="info-value">{{ shift.shift_offset }} days</span>
              </div>
              
              <div class="info-item">
                <span class="info-label">Ground Zero:</span>
                <span class="info-value">{{ new Date(shift.ground_zero).toLocaleDateString() }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
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
  font-weight: 600;
  color: var(--color-neutral-900);
  margin: 0 0 var(--space-2) 0;
}

.manager-description {
  font-size: var(--font-size-base);
  color: var(--color-neutral-600);
  margin: 0;
}

.loading-state {
  text-align: center;
  padding: var(--space-16);
  color: var(--color-neutral-600);
}

.loading-spinner {
  width: 32px;
  height: 32px;
  border: 3px solid var(--color-neutral-200);
  border-top: 3px solid var(--color-primary);
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin: 0 auto var(--space-4) auto;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.empty-state {
  text-align: center;
  padding: var(--space-16);
}

.empty-state h3 {
  font-size: var(--font-size-xl);
  color: var(--color-neutral-700);
  margin-bottom: var(--space-4);
}

.empty-state p {
  color: var(--color-neutral-600);
  margin-bottom: var(--space-6);
}

.shifts-grid {
  display: grid;
  gap: var(--space-6);
  grid-template-columns: 1fr;
}

@container (min-width: 768px) {
  .shifts-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@container (min-width: 1200px) {
  .shifts-grid {
    grid-template-columns: repeat(3, 1fr);
  }
}

.shift-card {
  background-color: white;
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-sm);
  border: 1px solid var(--color-neutral-200);
  overflow: hidden;
}

.card-header {
  padding: var(--space-6);
  border-bottom: 1px solid var(--color-neutral-200);
  background-color: var(--color-neutral-50);
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.shift-name {
  font-size: var(--font-size-lg);
  font-weight: 600;
  color: var(--color-neutral-900);
  margin: 0;
}

.shift-badges {
  display: flex;
  gap: var(--space-2);
}

.shift-type,
.shift-ident {
  font-size: var(--font-size-xs);
  color: var(--color-neutral-500);
  text-transform: uppercase;
  font-weight: 500;
  padding: var(--space-1) var(--space-2);
  background-color: var(--color-neutral-200);
  border-radius: var(--radius-sm);
}

.shift-type {
  background-color: var(--color-primary);
  color: white;
}

.card-body {
  padding: var(--space-6);
}

.shift-info {
  display: flex;
  flex-direction: column;
  gap: var(--space-3);
}

.info-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--space-2) 0;
  border-bottom: 1px solid var(--color-neutral-100);
}

.info-item:last-child {
  border-bottom: none;
}

.info-label {
  font-weight: 500;
  color: var(--color-neutral-700);
  font-size: var(--font-size-sm);
}

.info-value {
  color: var(--color-neutral-600);
  font-size: var(--font-size-sm);
}

@container (max-width: 768px) {
  .manager-header {
    flex-direction: column;
    align-items: stretch;
  }
  
  .card-header {
    flex-direction: column;
    align-items: flex-start;
    gap: var(--space-3);
  }
}
</style>
