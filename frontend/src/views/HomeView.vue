<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { departmentApi, serviceApi } from '@/services/api'
import type { Department, Service, WeekTab, ScheduleDay, ActiveShift } from '@/types'
import WeekNavigation from '@/components/WeekNavigation.vue'
import ShiftCard from '@/components/ShiftCard.vue'

// State
const scheduleData = ref<ScheduleDay | null>(null)
const loading = ref(true)
const error = ref<string | null>(null)
const selectedWeek = ref<WeekTab | null>(null)
const selectedDate = ref(new Date())

// Computed properties
const currentDateString = computed(() => {
  return selectedDate.value.toLocaleDateString('en-GB', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
})

const departmentsList = computed(() => scheduleData.value?.departments || [])
const servicesList = computed(() => scheduleData.value?.services || [])
const activeShifts = computed(() => scheduleData.value?.active_shifts || [])

// Extract all porter assignments from active shifts
const allPorterAssignments = computed(() => {
  const assignments: any[] = []
  activeShifts.value.forEach(shift => {
    shift.assigned_porters.forEach((assignment: any) => {
      assignments.push(assignment)
    })
  })
  return assignments
})

// Group porters by department (regular assignments)
const portersByDepartment = computed(() => {
  const grouped: Record<number, any[]> = {}
  allPorterAssignments.value.forEach(assignment => {
    const porter = assignment.porter
    if (porter.regular_department_id) {
      if (!grouped[porter.regular_department_id]) {
        grouped[porter.regular_department_id] = []
      }
      grouped[porter.regular_department_id].push({
        ...assignment,
        assignment_type: 'Regular'
      })
    }
  })
  return grouped
})

// Group porters by service (temporary assignments)
const portersByService = computed(() => {
  const grouped: Record<number, any[]> = {}
  allPorterAssignments.value.forEach(assignment => {
    const porter = assignment.porter
    if (porter.temp_service_id) {
      if (!grouped[porter.temp_service_id]) {
        grouped[porter.temp_service_id] = []
      }
      grouped[porter.temp_service_id].push({
        ...assignment,
        assignment_type: 'Temporary'
      })
    }
  })
  return grouped
})

// Group porters by department (temporary assignments)
const tempPortersByDepartment = computed(() => {
  const grouped: Record<number, any[]> = {}
  allPorterAssignments.value.forEach(assignment => {
    const porter = assignment.porter
    if (porter.temp_department_id) {
      if (!grouped[porter.temp_department_id]) {
        grouped[porter.temp_department_id] = []
      }
      grouped[porter.temp_department_id].push({
        ...assignment,
        assignment_type: 'Temporary'
      })
    }
  })
  return grouped
})

// Week days for the selected week
const weekDays = computed(() => {
  if (!selectedWeek.value) return []

  const startDate = selectedWeek.value.start_date
  const days = []
  for (let i = 0; i < 7; i++) {
    const date = new Date(startDate)
    date.setDate(startDate.getDate() + i)
    days.push(date)
  }
  return days
})

// Methods
async function loadScheduleData(date: Date) {
  try {
    loading.value = true
    error.value = null

    const dateString = date.toISOString().split('T')[0] // YYYY-MM-DD format
    const response = await fetch(`/api/schedule/${dateString}`)

    if (!response.ok) {
      throw new Error('Failed to load schedule data')
    }

    const data = await response.json()
    scheduleData.value = data
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to load schedule data'
    console.error('Error loading schedule data:', err)
  } finally {
    loading.value = false
  }
}

function onWeekSelected(week: WeekTab) {
  selectedWeek.value = week
  selectedDate.value = week.start_date
  loadScheduleData(week.start_date)
}

function selectDate(date: Date) {
  selectedDate.value = new Date(date)
  loadScheduleData(date)
}

function goToToday() {
  const today = new Date()
  selectedDate.value = today
  loadScheduleData(today)
}

// Lifecycle
onMounted(() => {
  // Initial load will be triggered by WeekNavigation component
})
</script>

<template>
  <div class="home-view">
    <!-- Page Header -->
    <div class="page-header">
      <div class="page-title-section">
        <h1 class="page-title">Porter Schedule</h1>
        <p class="page-subtitle">{{ currentDateString }}</p>
      </div>
    </div>

    <!-- 3-Week Navigation -->
    <WeekNavigation @week-selected="onWeekSelected" />

    <!-- Day Navigation within Selected Week -->
    <div v-if="selectedWeek" class="day-navigation">
      <div class="week-days">
        <button
          v-for="day in weekDays"
          :key="day.toISOString()"
          @click="selectDate(day)"
          :class="[
            'day-button',
            {
              'day-button--selected': day.toDateString() === selectedDate.toDateString(),
              'day-button--today': day.toDateString() === new Date().toDateString()
            }
          ]"
        >
          <span class="day-name">{{ day.toLocaleDateString('en-GB', { weekday: 'short' }) }}</span>
          <span class="day-number">{{ day.getDate() }}</span>
        </button>
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="loading-state">
      <div class="loading-spinner"></div>
      <p>Loading schedule...</p>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="alert alert-error">
      <p>{{ error }}</p>
      <button @click="loadData" class="btn btn-sm btn-secondary">
        Try Again
      </button>
    </div>

    <!-- Schedule Content -->
    <div v-else class="schedule-container">
      <!-- Departments Section (includes shift cards) -->
      <div class="section">
        <h2 class="section-title">Departments & Active Shifts</h2>
        <div class="schedule-grid">
          <!-- Department Cards -->
          <div
            v-for="department in departmentsList"
            :key="`dept-${department.id}`"
            class="department-card"
          >
            <div class="department-header">
              <h3 class="department-name">{{ department.name }}</h3>
              <div class="department-info">
                <span class="department-type">
                  {{ department.is_24_7 ? '24/7' : 'Scheduled' }}
                </span>
                <span class="porter-count">
                  Day: {{ department.porters_required_day }}, Night: {{ department.porters_required_night }} porters
                </span>
              </div>
            </div>

            <div class="department-body">
              <!-- Department Hours (if not 24/7) -->
              <div v-if="!department.is_24_7" class="department-hours">
                <h4 class="hours-title">Operating Hours</h4>
                <div class="hours-info">
                  <span class="hours-note">Standard operating hours apply</span>
                </div>
              </div>

              <!-- Assigned Porters -->
              <div class="assigned-porters">
                <h4 class="porters-title">Assigned Porters</h4>
                <div class="porters-list">
                  <!-- Regular Assignments -->
                  <div
                    v-for="assignment in portersByDepartment[department.id] || []"
                    :key="`regular-${assignment.porter.id}`"
                    class="porter-item"
                  >
                    <span class="porter-name">{{ assignment.porter.name }}</span>
                    <span class="assignment-type regular">{{ assignment.assignment_type }}</span>
                  </div>

                  <!-- Temporary Assignments -->
                  <div
                    v-for="assignment in tempPortersByDepartment[department.id] || []"
                    :key="`temp-${assignment.porter.id}`"
                    class="porter-item"
                  >
                    <span class="porter-name">{{ assignment.porter.name }}</span>
                    <span class="assignment-type temporary">{{ assignment.assignment_type }}</span>
                  </div>

                  <div v-if="(!portersByDepartment[department.id] || portersByDepartment[department.id].length === 0) && (!tempPortersByDepartment[department.id] || tempPortersByDepartment[department.id].length === 0)" class="no-porters">
                    No porters currently assigned
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Active Shift Cards -->
          <ShiftCard
            v-for="shift in activeShifts"
            :key="`shift-${shift.shift.id}`"
            :shift="shift"
            class="shift-card-item"
          />
        </div>
      </div>

      <!-- Services Section -->
      <div class="section">
        <h2 class="section-title">Services</h2>
        <div class="schedule-grid">
          <div
            v-for="service in servicesList"
            :key="service.id"
            class="department-card service-card"
          >
            <div class="department-header">
              <h3 class="department-name">{{ service.name }}</h3>
              <div class="department-info">
                <span class="department-type">
                  {{ service.is_24_7 ? '24/7' : 'Scheduled' }}
                </span>
                <span class="porter-count">
                  Day: {{ service.porters_required_day }}, Night: {{ service.porters_required_night }} porters
                </span>
              </div>
            </div>

            <div class="department-body">
              <!-- Service Hours (if not 24/7) -->
              <div v-if="!service.is_24_7" class="department-hours">
                <h4 class="hours-title">Operating Hours</h4>
                <div class="hours-info">
                  <span class="hours-note">Standard operating hours apply</span>
                </div>
              </div>

              <!-- Assigned Porters -->
              <div class="assigned-porters">
                <h4 class="porters-title">Assigned Porters</h4>
                <div class="porters-list">
                  <div
                    v-for="assignment in portersByService[service.id] || []"
                    :key="`service-${assignment.porter.id}`"
                    class="porter-item"
                  >
                    <span class="porter-name">{{ assignment.porter.name }}</span>
                    <span class="assignment-type temporary">{{ assignment.assignment_type }}</span>
                  </div>

                  <div v-if="!portersByService[service.id] || portersByService[service.id].length === 0" class="no-porters">
                    No porters currently assigned
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Empty State -->
    <div v-if="!loading && !error && departmentsList.length === 0" class="empty-state">
      <h3>No Departments Found</h3>
      <p>Get started by configuring departments and porters.</p>
      <router-link to="/configure" class="btn btn-primary">
        Go to Configuration
      </router-link>
    </div>
  </div>
</template>

<style scoped>
.home-view {
  container-type: inline-size;
}

.page-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: var(--space-8);
  gap: var(--space-6);
}

.page-title-section {
  flex: 1;
}

.page-title {
  font-size: var(--font-size-3xl);
  font-weight: 700;
  color: var(--color-neutral-900);
  margin: 0 0 var(--space-2) 0;
}

.page-subtitle {
  font-size: var(--font-size-lg);
  color: var(--color-neutral-600);
  margin: 0;
}

.day-navigation {
  margin: var(--space-6) 0;
  padding: var(--space-4);
  background-color: var(--color-neutral-50);
  border-radius: var(--radius-lg);
  border: 1px solid var(--color-neutral-200);
}

.day-navigation .week-days {
  display: flex;
  gap: var(--space-2);
  justify-content: center;
}

.week-days {
  display: flex;
  gap: var(--space-1);
  background-color: var(--color-neutral-100);
  border-radius: var(--radius-lg);
  padding: var(--space-1);
}

.day-button {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: var(--space-2) var(--space-3);
  border: none;
  background: transparent;
  border-radius: var(--radius-md);
  cursor: pointer;
  transition: all 0.2s ease;
  min-width: 48px;
}

.day-button:hover {
  background-color: var(--color-neutral-200);
}

.day-button--selected {
  background-color: var(--color-primary);
  color: white;
}

.day-button--selected:hover {
  background-color: var(--color-primary);
}

.day-button--today {
  font-weight: 600;
}

.day-name {
  font-size: var(--font-size-xs);
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.day-number {
  font-size: var(--font-size-sm);
  font-weight: 600;
  margin-top: var(--space-1);
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

.schedule-container {
  display: flex;
  flex-direction: column;
  gap: var(--space-12);
}

.section {
  display: flex;
  flex-direction: column;
  gap: var(--space-6);
}

.section-title {
  font-size: var(--font-size-2xl);
  font-weight: 600;
  color: var(--color-neutral-900);
  margin: 0;
  padding-bottom: var(--space-4);
  border-bottom: 2px solid var(--color-neutral-200);
}

.schedule-grid {
  display: grid;
  gap: var(--space-6);
  grid-template-columns: 1fr;
}

@container (min-width: 768px) {
  .schedule-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@container (min-width: 1200px) {
  .schedule-grid {
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

.service-card {
}

.department-header {
  padding: var(--space-6);
  border-bottom: 1px solid var(--color-neutral-200);
  background-color: var(--color-neutral-50);
}

.department-name {
  font-size: var(--font-size-lg);
  font-weight: 600;
  color: var(--color-neutral-900);
  margin: 0 0 var(--space-3) 0;
}

.department-info {
  display: flex;
  gap: var(--space-4);
  flex-wrap: wrap;
}

.department-type,
.porter-count {
  font-size: var(--font-size-xs);
  color: var(--color-neutral-500);
  text-transform: uppercase;
  font-weight: 500;
  padding: var(--space-1) var(--space-2);
  background-color: var(--color-neutral-200);
  border-radius: var(--radius-sm);
}

.department-body {
  padding: var(--space-6);
  display: flex;
  flex-direction: column;
  gap: var(--space-6);
}

.hours-title,
.porters-title {
  font-size: var(--font-size-sm);
  font-weight: 600;
  color: var(--color-neutral-700);
  margin: 0 0 var(--space-3) 0;
}

.hours-list {
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
  border-radius: var(--radius-sm);
  font-size: var(--font-size-sm);
}

.day-name {
  font-weight: 500;
  color: var(--color-neutral-700);
}

.time-range {
  color: var(--color-neutral-600);
}

.porter-requirement {
  color: var(--color-neutral-500);
  text-align: right;
}

.porters-list {
  display: flex;
  flex-direction: column;
  gap: var(--space-2);
}

.porter-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--space-3);
  background-color: var(--color-neutral-50);
  border-radius: var(--radius-sm);
  border-left: 3px solid var(--color-primary);
}

.porter-name {
  font-weight: 500;
  color: var(--color-neutral-900);
}

.assignment-type {
  font-size: var(--font-size-xs);
  text-transform: uppercase;
  font-weight: 500;
  padding: var(--space-1) var(--space-2);
  border-radius: var(--radius-sm);
}

.assignment-type.regular {
  color: var(--color-blue-700);
  background-color: var(--color-blue-100);
}

.assignment-type.temporary {
  color: var(--color-orange-700);
  background-color: var(--color-orange-100);
}

.no-porters {
  padding: var(--space-4);
  text-align: center;
  color: var(--color-neutral-500);
  font-style: italic;
  background-color: var(--color-neutral-50);
  border-radius: var(--radius-sm);
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

@container (max-width: 768px) {
  .page-header {
    flex-direction: column;
    align-items: stretch;
    gap: var(--space-4);
  }

  .week-navigation {
    justify-content: space-between;
  }

  .week-days {
    flex: 1;
    justify-content: space-between;
  }

  .day-button {
    min-width: auto;
    flex: 1;
  }

  .department-info {
    flex-direction: column;
    gap: var(--space-2);
  }

  .hours-item {
    grid-template-columns: 1fr;
    text-align: center;
  }

  .porter-requirement {
    text-align: center;
  }
}
</style>
