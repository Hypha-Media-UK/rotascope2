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
          Manage porter details, contracted hours, and assignments
        </p>
      </div>
      
      <button class="btn btn-primary" disabled>
        Add Porter (Coming Soon)
      </button>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="loading-state">
      <div class="loading-spinner"></div>
      <p>Loading porters...</p>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="alert alert-error">
      <p>{{ error }}</p>
      <button @click="loadPorters" class="btn btn-sm btn-secondary">
        Try Again
      </button>
    </div>

    <!-- Porters List -->
    <div v-else class="porters-list">
      <div v-if="porters.length === 0" class="empty-state">
        <h3>No Porters</h3>
        <p>Porter management will be available soon.</p>
      </div>

      <div v-else class="porters-grid">
        <div
          v-for="porter in porters"
          :key="porter.id"
          class="porter-card"
        >
          <div class="card-header">
            <h3 class="porter-name">{{ porter.name }}</h3>
            <span class="porter-type">{{ porter.porter_type }}</span>
          </div>

          <div class="card-body">
            <div class="porter-info">
              <div class="info-item">
                <span class="info-label">Contract Type:</span>
                <span class="info-value">{{ porter.contracted_hours_type }}</span>
              </div>
              
              <div class="info-item">
                <span class="info-label">Floor Staff:</span>
                <span class="info-value">{{ porter.is_floor_staff ? 'Yes' : 'No' }}</span>
              </div>
              
              <div class="info-item">
                <span class="info-label">Weekly Hours:</span>
                <span class="info-value">{{ porter.weekly_hours }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
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

.porters-grid {
  display: grid;
  gap: var(--space-6);
  grid-template-columns: 1fr;
}

@container (min-width: 768px) {
  .porters-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@container (min-width: 1200px) {
  .porters-grid {
    grid-template-columns: repeat(3, 1fr);
  }
}

.porter-card {
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

.porter-name {
  font-size: var(--font-size-lg);
  font-weight: 600;
  color: var(--color-neutral-900);
  margin: 0;
}

.porter-type {
  font-size: var(--font-size-xs);
  color: var(--color-neutral-500);
  text-transform: uppercase;
  font-weight: 500;
  padding: var(--space-1) var(--space-2);
  background-color: var(--color-neutral-200);
  border-radius: var(--radius-sm);
}

.card-body {
  padding: var(--space-6);
}

.porter-info {
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
}
</style>
