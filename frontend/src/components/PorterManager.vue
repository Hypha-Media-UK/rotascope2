<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { porterApi } from '@/services/api'
import type { Porter } from '@/types'

// State
const porters = ref<Porter[]>([])
const loading = ref(true)
const error = ref<string | null>(null)

// Methods
async function loadPorters() {
  try {
    loading.value = true
    error.value = null
    porters.value = await porterApi.getAll()
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to load porters'
    console.error('Error loading porters:', err)
  } finally {
    loading.value = false
  }
}

// Lifecycle
onMounted(() => {
  loadPorters()
})
</script>

<template>
  <div class="porter-manager">
    <!-- Header -->
    <div class="manager-header">
      <div class="header-content">
        <h2 class="manager-title">Porters</h2>
        <p class="manager-description">
          Manage porter details, contracts, and assignments
        </p>
      </div>
      <button class="btn btn-primary" disabled>
        Add Porter
      </button>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="loading-state">
      <div class="loading-spinner"></div>
      <p>Loading porters...</p>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="error-state">
      <p class="error-message">{{ error }}</p>
      <button @click="loadPorters" class="btn btn-secondary">
        Try Again
      </button>
    </div>

    <!-- Porters Grid -->
    <div v-else class="porters-grid">
      <div v-for="porter in porters" :key="porter.id" class="porter-card">
        <div class="porter-header">
          <div class="porter-info">
            <h4 class="porter-name">{{ porter.first_name }} {{ porter.last_name }}</h4>
            <span class="porter-email">{{ porter.email }}</span>
          </div>
          <div class="porter-status">
            <span :class="['status-badge', porter.is_active ? 'status-active' : 'status-inactive']">
              {{ porter.is_active ? 'Active' : 'Inactive' }}
            </span>
          </div>
        </div>

        <div class="porter-details">
          <div class="detail-row">
            <span class="detail-label">Type:</span>
            <span class="detail-value">{{ porter.porter_type }}</span>
          </div>
          <div class="detail-row">
            <span class="detail-label">Contract:</span>
            <span class="detail-value">{{ porter.contract_type }}</span>
          </div>
          <div v-if="porter.custom_hours_per_week" class="detail-row">
            <span class="detail-label">Hours/Week:</span>
            <span class="detail-value">{{ porter.custom_hours_per_week }}</span>
          </div>
          <div class="detail-row">
            <span class="detail-label">Started:</span>
            <span class="detail-value">{{ new Date(porter.start_date).toLocaleDateString() }}</span>
          </div>
        </div>

        <div class="porter-actions">
          <button class="btn btn-secondary btn-sm" disabled>Edit</button>
          <button class="btn btn-danger btn-sm" disabled>Delete</button>
        </div>
      </div>
    </div>

    <!-- Empty State -->
    <div v-if="!loading && !error && porters.length === 0" class="empty-state">
      <p>No porters found</p>
    </div>
  </div>
</template>

<style scoped>
.porter-manager {
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

.porters-grid {
  display: grid;
  gap: var(--space-6);
  grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
}

.porter-card {
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  padding: var(--space-6);
  transition: all 0.2s ease;
}

.porter-card:hover {
  border-color: var(--color-primary);
  box-shadow: var(--shadow-md);
}

.porter-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  margin-bottom: var(--space-4);
  gap: var(--space-4);
}

.porter-info {
  flex: 1;
}

.porter-name {
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-semibold);
  color: var(--color-text-primary);
  margin: 0 0 var(--space-1) 0;
}

.porter-email {
  color: var(--color-text-secondary);
  font-size: var(--font-size-sm);
}

.porter-details {
  display: flex;
  flex-direction: column;
  gap: var(--space-2);
  margin-bottom: var(--space-4);
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

.porter-actions {
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
  .porters-grid {
    grid-template-columns: 1fr;
  }
  
  .manager-header {
    flex-direction: column;
    align-items: flex-start;
    gap: var(--space-4);
  }
}
</style>
