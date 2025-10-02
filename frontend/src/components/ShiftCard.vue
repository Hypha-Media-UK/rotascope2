<template>
  <div class="shift-card">
    <div class="shift-header">
      <div class="shift-title">
        <h3 class="shift-name">{{ shift.shift.name }}</h3>
        <span class="shift-times">{{ formatShiftTimes(shift.shift) }}</span>
      </div>
      <div class="shift-status">
        <span :class="['status-badge', { 'status-badge--active': shift.is_active_today }]">
          {{ shift.is_active_today ? 'Active' : 'Inactive' }}
        </span>
      </div>
    </div>

    <div class="shift-info">
      <div class="shift-detail">
        <span class="detail-label">Type:</span>
        <span class="detail-value">
          <span v-if="shift.shift.shift_type_id && shift.shift.shift_type"
                :style="{ color: shift.shift.shift_type.color }"
                class="shift-type-badge">
            {{ shift.shift.shift_type.name }} ({{ shift.shift.shift_type.display_type }})
          </span>
          <span v-else class="shift-type-badge custom">
            Custom Shift
          </span>
        </span>
      </div>
      <div class="shift-detail">
        <span class="detail-label">Pattern:</span>
        <span class="detail-value">{{ shift.shift.days_on }} on, {{ shift.shift.days_off }} off</span>
      </div>
      <div v-if="shift.shift.shift_offset" class="shift-detail">
        <span class="detail-label">Offset:</span>
        <span class="detail-value">{{ shift.shift.shift_offset }} days</span>
      </div>
    </div>

    <div class="porters-section">
      <h4 class="porters-title">
        Assigned Porters
        <span class="porter-count">({{ shift.assigned_porters.length }})</span>
      </h4>

      <div v-if="shift.assigned_porters.length === 0" class="no-porters">
        No porters assigned to this shift
      </div>

      <div v-else class="porters-list">
        <div
          v-for="assignment in shift.assigned_porters"
          :key="assignment.porter.id"
          :class="[
            'porter-item',
            {
              'porter-item--inactive': !assignment.is_active_today,
              'porter-item--temp-assigned': assignment.is_temporarily_assigned
            }
          ]"
        >
          <div class="porter-info">
            <span class="porter-name">{{ assignment.porter.name }}</span>
            <div class="porter-details">
              <span v-if="assignment.porter.porter_offset" class="porter-offset">
                Offset: +{{ assignment.porter.porter_offset }}d
              </span>
              <span v-if="assignment.porter.regular_department_name" class="porter-department">
                {{ assignment.porter.regular_department_name }}
              </span>
            </div>
          </div>

          <div class="porter-status">
            <span v-if="!assignment.is_active_today" class="status-indicator status-indicator--inactive">
              Off Today
            </span>
            <span v-else-if="assignment.is_temporarily_assigned" class="status-indicator status-indicator--temp">
              → {{ assignment.temp_assignment_location }}
            </span>
            <span v-else class="status-indicator status-indicator--active">
              On Shift
            </span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { ActiveShift } from '@/types'

interface Props {
  shift: ActiveShift
}

defineProps<Props>()

function formatShiftTimes(shift: any): string {
  const start = shift.starts_at.slice(0, 5) // Remove seconds
  const end = shift.ends_at.slice(0, 5)
  return `${start} - ${end}`
}
</script>

<style scoped>
.shift-card {
  background-color: white;
  border: 1px solid var(--color-neutral-200);
  border-radius: var(--radius-lg);
  padding: var(--space-4);
  transition: all 0.2s ease;
  box-shadow: 0 1px 3px rgb(0 0 0 / 0.1);
}

.shift-card:hover {
  border-color: var(--color-neutral-300);
  box-shadow: 0 4px 6px rgb(0 0 0 / 0.1);
}

.shift-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: var(--space-3);
}

.shift-title {
  flex: 1;
}

.shift-name {
  font-size: var(--font-size-lg);
  font-weight: 600;
  color: var(--color-neutral-900);
  margin: 0 0 var(--space-1) 0;
}

.shift-times {
  font-size: var(--font-size-sm);
  color: var(--color-neutral-600);
  font-weight: 500;
}

.shift-status {
  margin-left: var(--space-3);
}

.status-badge {
  padding: var(--space-1) var(--space-2);
  border-radius: var(--radius-full);
  font-size: var(--font-size-xs);
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  background-color: var(--color-neutral-100);
  color: var(--color-neutral-600);
}

.status-badge--active {
  background-color: rgb(34 197 94 / 0.1);
  color: rgb(21 128 61);
}

.shift-info {
  display: flex;
  gap: var(--space-4);
  margin-bottom: var(--space-4);
  padding-bottom: var(--space-3);
  border-bottom: 1px solid var(--color-neutral-100);
}

.shift-detail {
  display: flex;
  flex-direction: column;
  gap: var(--space-1);
}

.detail-label {
  font-size: var(--font-size-xs);
  color: var(--color-neutral-500);
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.detail-value {
  font-size: var(--font-size-sm);
  color: var(--color-neutral-900);
  font-weight: 500;
}

.shift-type-badge {
  display: inline-block;
  padding: var(--space-1) var(--space-2);
  border-radius: var(--radius-sm);
  font-size: var(--font-size-xs);
  font-weight: 600;
  background-color: rgba(var(--color-primary-rgb), 0.1);
  border: 1px solid rgba(var(--color-primary-rgb), 0.2);
}

.shift-type-badge.custom {
  background-color: var(--color-neutral-100);
  color: var(--color-neutral-600);
  border-color: var(--color-neutral-200);
}

.porters-section {
  margin-top: var(--space-4);
}

.porters-title {
  font-size: var(--font-size-sm);
  font-weight: 600;
  color: var(--color-neutral-900);
  margin: 0 0 var(--space-3) 0;
  display: flex;
  align-items: center;
  gap: var(--space-2);
}

.porter-count {
  font-size: var(--font-size-xs);
  color: var(--color-neutral-500);
  font-weight: 500;
}

.no-porters {
  color: var(--color-neutral-500);
  font-size: var(--font-size-sm);
  font-style: italic;
  text-align: center;
  padding: var(--space-3);
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
  padding: var(--space-2) var(--space-3);
  background-color: var(--color-neutral-50);
  border-radius: var(--radius-md);
  border: 1px solid var(--color-neutral-200);
  transition: all 0.2s ease;
}

.porter-item--inactive {
  opacity: 0.6;
  background-color: var(--color-neutral-25);
}

.porter-item--temp-assigned {
  background-color: rgb(251 191 36 / 0.1);
  border-color: rgb(251 191 36 / 0.3);
}

.porter-info {
  flex: 1;
}

.porter-name {
  font-weight: 500;
  color: var(--color-neutral-900);
  display: block;
  margin-bottom: var(--space-1);
}

.porter-details {
  display: flex;
  gap: var(--space-3);
  font-size: var(--font-size-xs);
  color: var(--color-neutral-600);
}

.porter-offset {
  font-weight: 500;
  color: var(--color-blue-600);
}

.porter-department {
  color: var(--color-neutral-500);
}

.porter-status {
  margin-left: var(--space-3);
}

.status-indicator {
  padding: var(--space-1) var(--space-2);
  border-radius: var(--radius-full);
  font-size: var(--font-size-xs);
  font-weight: 500;
  white-space: nowrap;
}

.status-indicator--active {
  background-color: rgb(34 197 94 / 0.1);
  color: rgb(21 128 61);
}

.status-indicator--inactive {
  background-color: var(--color-neutral-100);
  color: var(--color-neutral-600);
}

.status-indicator--temp {
  background-color: rgb(251 191 36 / 0.1);
  color: rgb(146 64 14);
  font-weight: 600;
}

@container (max-width: 480px) {
  .shift-info {
    flex-direction: column;
    gap: var(--space-2);
  }

  .porter-item {
    flex-direction: column;
    align-items: flex-start;
    gap: var(--space-2);
  }

  .porter-status {
    margin-left: 0;
    align-self: flex-end;
  }
}
</style>
