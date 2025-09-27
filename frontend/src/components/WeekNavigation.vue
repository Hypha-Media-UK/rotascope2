<template>
  <div class="week-navigation">
    <!-- Previous/Next Navigation -->
    <button @click="goToPreviousWeek" class="nav-button nav-button--prev">
      <span class="nav-icon">‹</span>
      Previous
    </button>

    <!-- Week Tabs -->
    <div class="week-tabs">
      <button
        v-for="week in weekTabs"
        :key="week.label"
        @click="selectWeek(week)"
        :class="[
          'week-tab',
          {
            'week-tab--current': week.is_current,
            'week-tab--selected': selectedWeek?.label === week.label
          }
        ]"
      >
        <span class="week-label">{{ week.label }}</span>
        <span class="week-dates">{{ formatWeekDates(week.start_date) }}</span>
      </button>
    </div>

    <!-- Next Navigation -->
    <button @click="goToNextWeek" class="nav-button nav-button--next">
      Next
      <span class="nav-icon">›</span>
    </button>

    <!-- Today Button -->
    <button @click="goToToday" class="btn btn-sm btn-secondary today-button">
      Today
    </button>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import type { WeekTab } from '@/types'

interface Emits {
  (e: 'week-selected', week: WeekTab): void
  (e: 'today-selected', week: WeekTab): void
}

const emit = defineEmits<Emits>()

// State
const currentWeekOffset = ref(0) // 0 = current week, 1 = next week, etc.
const selectedWeek = ref<WeekTab | null>(null)

// Computed
const weekTabs = computed(() => {
  const tabs: WeekTab[] = []
  const today = new Date()

  for (let i = 0; i < 3; i++) {
    const weekOffset = currentWeekOffset.value + i
    const startDate = getWeekStart(today, weekOffset)
    const isCurrent = weekOffset === 0

    tabs.push({
      label: formatWeekCommencing(startDate),
      start_date: startDate,
      is_current: isCurrent
    })
  }

  return tabs
})

// Methods
function getWeekStart(date: Date, weekOffset: number = 0): Date {
  const result = new Date(date)
  const day = result.getDay()
  const diff = result.getDate() - day + (day === 0 ? -6 : 1) // Adjust for Monday start
  result.setDate(diff + (weekOffset * 7))
  return result
}

function formatWeekCommencing(date: Date): string {
  const day = date.getDate().toString().padStart(2, '0')
  const month = (date.getMonth() + 1).toString().padStart(2, '0')
  const year = date.getFullYear().toString().slice(-2)
  return `w/c ${day}/${month}/${year}`
}

function formatWeekDates(startDate: Date): string {
  const endDate = new Date(startDate)
  endDate.setDate(startDate.getDate() + 6)

  const startDay = startDate.getDate()
  const endDay = endDate.getDate()
  const startMonth = startDate.toLocaleDateString('en-GB', { month: 'short' })
  const endMonth = endDate.toLocaleDateString('en-GB', { month: 'short' })

  if (startMonth === endMonth) {
    return `${startDay}-${endDay} ${startMonth}`
  } else {
    return `${startDay} ${startMonth} - ${endDay} ${endMonth}`
  }
}

function selectWeek(week: WeekTab) {
  selectedWeek.value = week
  emit('week-selected', week)
}

function goToPreviousWeek() {
  currentWeekOffset.value -= 1
  // Auto-select the first week when navigating
  setTimeout(() => {
    if (weekTabs.value.length > 0) {
      selectWeek(weekTabs.value[0])
    }
  }, 0)
}

function goToNextWeek() {
  currentWeekOffset.value += 1
  // Auto-select the first week when navigating
  setTimeout(() => {
    if (weekTabs.value.length > 0) {
      selectWeek(weekTabs.value[0])
    }
  }, 0)
}

function goToToday() {
  currentWeekOffset.value = 0
  // Auto-select current week and emit today-selected event
  setTimeout(() => {
    const currentWeek = weekTabs.value.find(w => w.is_current)
    if (currentWeek) {
      selectedWeek.value = currentWeek
      emit('today-selected', currentWeek)
    }
  }, 0)
}

// Auto-advance logic (would be implemented as a background job in production)
function checkAutoAdvance() {
  const now = new Date()
  const currentTime = now.getHours() * 60 + now.getMinutes()
  const advanceTime = 7 * 60 + 59 // 07:59

  // If it's past 07:59 and we haven't advanced today, advance the weeks
  if (currentTime >= advanceTime) {
    // This would be handled by a background job in production
    // For now, we'll just ensure the current week is properly set
  }
}

// Lifecycle
onMounted(() => {
  // Select current week and emit today-selected for initial load
  const currentWeek = weekTabs.value.find(w => w.is_current)
  if (currentWeek) {
    selectedWeek.value = currentWeek
    emit('today-selected', currentWeek)
  }

  // Check for auto-advance
  checkAutoAdvance()
})
</script>

<style scoped>
.week-navigation {
  display: flex;
  align-items: center;
  gap: var(--space-4);
  padding: var(--space-4);
  background-color: var(--color-neutral-50);
  border-radius: var(--radius-lg);
  border: 1px solid var(--color-neutral-200);
}

.nav-button {
  display: flex;
  align-items: center;
  gap: var(--space-2);
  padding: var(--space-2) var(--space-3);
  border: 1px solid var(--color-neutral-300);
  background-color: white;
  color: var(--color-neutral-700);
  border-radius: var(--radius-md);
  cursor: pointer;
  transition: all 0.2s ease;
  font-weight: 500;
}

.nav-button:hover {
  background-color: var(--color-neutral-100);
  border-color: var(--color-neutral-400);
}

.nav-icon {
  font-size: var(--font-size-lg);
  font-weight: bold;
}

.week-tabs {
  display: flex;
  gap: var(--space-1);
  flex: 1;
  justify-content: center;
}

.week-tab {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: var(--space-3) var(--space-4);
  border: 1px solid var(--color-neutral-300);
  background-color: white;
  border-radius: var(--radius-md);
  cursor: pointer;
  transition: all 0.2s ease;
  min-width: 120px;
}

.week-tab:hover {
  background-color: var(--color-neutral-100);
  border-color: var(--color-neutral-400);
}

.week-tab--current {
  border-color: var(--color-primary);
  background-color: rgb(37 99 235 / 0.05);
}

.week-tab--selected {
  background-color: var(--color-primary);
  color: white;
  border-color: var(--color-primary);
}

.week-tab--selected:hover {
  background-color: var(--color-primary);
}

.week-label {
  font-weight: 600;
  font-size: var(--font-size-sm);
  margin-bottom: var(--space-1);
}

.week-dates {
  font-size: var(--font-size-xs);
  opacity: 0.8;
}

.week-tab--selected .week-dates {
  opacity: 0.9;
}

.today-button {
  margin-left: var(--space-2);
}

@container (max-width: 768px) {
  .week-navigation {
    flex-direction: column;
    gap: var(--space-3);
  }

  .week-tabs {
    order: -1;
    width: 100%;
  }

  .week-tab {
    flex: 1;
    min-width: auto;
  }

  .nav-button {
    flex: 1;
  }
}
</style>
