<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { porterApi } from '@/services/api'
import type { Porter, PorterFormData } from '@/types'
import CrudCard from './CrudCard.vue'
import PorterModal from './PorterModal.vue'

// State
const porters = ref<Porter[]>([])
const loading = ref(true)
const error = ref<string | null>(null)
const showModal = ref(false)
const editingPorter = ref<Porter | null>(null)

// Computed
const isEditing = computed(() => editingPorter.value !== null)

// Methods
async function loadData() {
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

// Modal methods
function openCreateModal() {
  editingPorter.value = null
  showModal.value = true
}

function openEditModal(porter: Porter) {
  editingPorter.value = porter
  showModal.value = true
}

function closeModal() {
  showModal.value = false
  editingPorter.value = null
}

async function handleSave(formData: PorterFormData) {
  try {
    if (isEditing.value && editingPorter.value) {
      await porterApi.update(editingPorter.value.id, formData)
    } else {
      await porterApi.create(formData)
    }

    await loadData()
    closeModal()
  } catch (err) {
    console.error('Error saving porter:', err)
    throw err // Let the modal handle the error display
  }
}

async function handleDelete(porter: Porter) {
  if (!confirm(`Are you sure you want to delete "${porter.first_name} ${porter.last_name}"?`)) {
    return
  }

  try {
    await porterApi.delete(porter.id)
    await loadData()
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to delete porter'
    console.error('Error deleting porter:', err)
  }
}

function getPorterInfoItems(porter: Porter) {
  return [
    { label: 'Contract', value: porter.contracted_hours_type.replace('_', ' ') },
    { label: 'Hours/Week', value: `${porter.weekly_contracted_hours}` }
  ]
}

// Lifecycle
onMounted(() => {
  loadData()
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
      <button class="btn btn-primary" @click="openCreateModal">
        Add Porter
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
      <button @click="loadData" class="btn btn-sm btn-secondary">
        Try Again
      </button>
    </div>

    <!-- Empty State -->
    <div v-else-if="porters.length === 0" class="empty-state">
      <h3>No Porters</h3>
      <p>Create your first porter to get started.</p>
      <button @click="openCreateModal" class="btn btn-primary">
        Add Porter
      </button>
    </div>

    <!-- Porters Grid -->
    <div v-else class="departments-grid">
      <CrudCard
        v-for="porter in porters"
        :key="porter.id"
        :title="porter.name"
        :info-items="getPorterInfoItems(porter)"
        @edit="openEditModal(porter)"
        @delete="handleDelete(porter)"
      />
    </div>

    <!-- Porter Modal -->
    <PorterModal
      v-if="showModal"
      :porter="editingPorter"
      @save="handleSave"
      @close="closeModal"
    />
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
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: var(--space-12);
  text-align: center;
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

/* Removed old porter-specific styles - now using CrudCard component */



@container (max-width: 768px) {
  .manager-header {
    flex-direction: column;
    align-items: flex-start;
    gap: var(--space-4);
  }
}
</style>
