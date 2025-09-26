<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { departmentApi, serviceApi } from '@/services/api'
import type { DepartmentWithHours, DepartmentFormData, Service } from '@/types'
import { DAY_NAMES } from '@/types'
import DepartmentModal from './DepartmentModal.vue'

// State
const departments = ref<DepartmentWithHours[]>([])
const services = ref<Service[]>([])
const loading = ref(true)
const error = ref<string | null>(null)
const showModal = ref(false)
const editingDepartment = ref<DepartmentWithHours | null>(null)

// Computed
const isEditing = computed(() => editingDepartment.value !== null)

// Methods
async function loadData() {
  try {
    loading.value = true
    error.value = null
    const [departmentsData, servicesData] = await Promise.all([
      departmentApi.getAll(),
      serviceApi.getAll()
    ])
    departments.value = departmentsData
    services.value = servicesData
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to load data'
    console.error('Error loading data:', err)
  } finally {
    loading.value = false
  }
}

function openCreateModal() {
  editingDepartment.value = null
  showModal.value = true
}

function openEditModal(department: DepartmentWithHours) {
  editingDepartment.value = department
  showModal.value = true
}

function closeModal() {
  showModal.value = false
  editingDepartment.value = null
}

async function handleSave(formData: DepartmentFormData) {
  try {
    if (isEditing.value && editingDepartment.value) {
      await departmentApi.update(editingDepartment.value.id, formData)
    } else {
      await departmentApi.create(formData)
    }

    await loadDepartments()
    closeModal()
  } catch (err) {
    console.error('Error saving department:', err)
    throw err // Let the modal handle the error display
  }
}

async function handleDelete(department: DepartmentWithHours) {
  if (!confirm(`Are you sure you want to delete "${department.name}"?`)) {
    return
  }

  try {
    await departmentApi.delete(department.id)
    await loadDepartments()
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to delete department'
    console.error('Error deleting department:', err)
  }
}

function formatOperatingHours(department: DepartmentWithHours): string {
  if (department.is_24_7) {
    return '24/7 Operation'
  }

  if (department.hours.length === 0) {
    return 'No operating hours set'
  }

  return department.hours
    .map(h => `${DAY_NAMES[h.day_of_week]}: ${h.opens_at.slice(0, 5)} - ${h.closes_at.slice(0, 5)}`)
    .join(', ')
}

// Lifecycle
onMounted(() => {
  loadData()
})
</script>

<template>
  <div class="department-manager">
    <!-- Header -->
    <div class="manager-header">
      <div class="header-content">
        <h2 class="manager-title">Departments & Services</h2>
        <p class="manager-description">
          Manage hospital departments and services with their operational hours
        </p>
      </div>

      <button @click="openCreateModal" class="btn btn-primary">
        Add Department
      </button>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="loading-state">
      <div class="loading-spinner"></div>
      <p>Loading departments...</p>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="alert alert-error">
      <p>{{ error }}</p>
      <button @click="loadDepartments" class="btn btn-sm btn-secondary">
        Try Again
      </button>
    </div>

    <!-- Departments List -->
    <div v-else class="departments-list">
      <div v-if="departments.length === 0" class="empty-state">
        <h3>No Departments</h3>
        <p>Create your first department to get started.</p>
        <button @click="openCreateModal" class="btn btn-primary">
          Add Department
        </button>
      </div>

      <div v-else class="departments-grid">
        <div
          v-for="department in departments"
          :key="department.id"
          class="department-card"
        >
          <div class="card-header">
            <h3 class="department-name">{{ department.name }}</h3>
            <div class="card-actions">
              <button
                @click="openEditModal(department)"
                class="btn btn-sm btn-secondary"
              >
                Edit
              </button>
              <button
                @click="handleDelete(department)"
                class="btn btn-sm btn-secondary"
              >
                Delete
              </button>
            </div>
          </div>

          <div class="card-body">
            <div class="department-info">
              <div class="info-item">
                <span class="info-label">Type:</span>
                <span class="info-value">
                  {{ department.is_24_7 ? '24/7 Operation' : 'Scheduled Hours' }}
                </span>
              </div>

              <div class="info-item">
                <span class="info-label">Porters Required:</span>
                <span class="info-value">
                  Day: {{ department.porters_required_day }}, Night: {{ department.porters_required_night }}
                </span>
              </div>
            </div>

            <div v-if="!department.is_24_7" class="operating-hours">
              <h4 class="hours-title">Operating Hours</h4>
              <div class="hours-info">
                <span class="hours-note">Standard operating hours apply (not 24/7)</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Services Section -->
    <div class="services-section">
      <div class="section-header">
        <h3 class="section-title">Services</h3>
        <p class="section-description">Hospital services and their operational details</p>
      </div>

      <div class="services-grid">
        <div v-for="service in services" :key="service.id" class="service-card">
          <div class="service-header">
            <div class="service-info">
              <h4 class="service-name">{{ service.name }}</h4>
              <span class="service-code">{{ service.code }}</span>
            </div>
            <div class="service-status">
              <span :class="['status-badge', service.is_active ? 'status-active' : 'status-inactive']">
                {{ service.is_active ? 'Active' : 'Inactive' }}
              </span>
            </div>
          </div>

          <div class="service-details">
            <div class="porter-requirements">
              <h4 class="requirements-title">Porter Requirements</h4>
              <div class="requirements-grid">
                <span class="requirement-item">
                  <strong>Day:</strong> {{ service.porters_required_day }}
                </span>
                <span class="requirement-item">
                  <strong>Night:</strong> {{ service.porters_required_night }}
                </span>
              </div>
            </div>

            <div v-if="!service.is_24_7" class="operating-hours">
              <h4 class="hours-title">Operating Hours</h4>
              <div class="hours-info">
                <span class="hours-note">Standard operating hours apply (not 24/7)</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Department Modal -->
    <DepartmentModal
      v-if="showModal"
      :department="editingDepartment"
      @save="handleSave"
      @close="closeModal"
    />
  </div>
</template>

<style scoped>
.department-manager {
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

.departments-grid {
  display: grid;
  gap: var(--space-6);
  grid-template-columns: 1fr;
}

@container (min-width: 768px) {
  .departments-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@container (min-width: 1200px) {
  .departments-grid {
    grid-template-columns: repeat(3, 1fr);
  }
}

.department-card {
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

.department-name {
  font-size: var(--font-size-lg);
  font-weight: 600;
  color: var(--color-neutral-900);
  margin: 0;
}

.card-actions {
  display: flex;
  gap: var(--space-2);
}

.card-body {
  padding: var(--space-6);
}

.department-info {
  margin-bottom: var(--space-6);
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

.hours-title {
  font-size: var(--font-size-base);
  font-weight: 600;
  color: var(--color-neutral-800);
  margin: 0 0 var(--space-3) 0;
}

.hours-grid {
  display: flex;
  flex-direction: column;
  gap: var(--space-2);
}

.hours-item {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  gap: var(--space-2);
  padding: var(--space-2);
  background-color: var(--color-neutral-50);
  border-radius: var(--radius-md);
  font-size: var(--font-size-sm);
}

.day {
  font-weight: 500;
  color: var(--color-neutral-700);
}

.time {
  color: var(--color-neutral-600);
}

.porters {
  color: var(--color-neutral-500);
  text-align: right;
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

  .card-actions {
    align-self: stretch;
    justify-content: center;
  }
}

/* Services Section */
.services-section {
  margin-top: var(--space-12);
  padding-top: var(--space-8);
  border-top: 1px solid var(--color-border);
}

.section-header {
  margin-bottom: var(--space-6);
}

.section-title {
  font-size: var(--font-size-xl);
  font-weight: var(--font-weight-semibold);
  color: var(--color-text-primary);
  margin: 0 0 var(--space-2) 0;
}

.section-description {
  color: var(--color-text-secondary);
  margin: 0;
}

.services-grid {
  display: grid;
  gap: var(--space-6);
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
}

.service-card {
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  padding: var(--space-6);
  transition: all 0.2s ease;
}

.service-card:hover {
  border-color: var(--color-primary);
  box-shadow: var(--shadow-md);
}

.service-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  margin-bottom: var(--space-4);
  gap: var(--space-4);
}

.service-info {
  flex: 1;
}

.service-name {
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-semibold);
  color: var(--color-text-primary);
  margin: 0 0 var(--space-1) 0;
}

.service-code {
  display: inline-block;
  background: var(--color-background-secondary);
  color: var(--color-text-secondary);
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
  padding: var(--space-1) var(--space-2);
  border-radius: var(--radius-sm);
  font-family: var(--font-mono);
}

.service-details {
  display: flex;
  flex-direction: column;
  gap: var(--space-4);
}
</style>
