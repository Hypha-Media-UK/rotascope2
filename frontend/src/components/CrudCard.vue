<template>
  <div class="department-card" :style="color ? { borderLeftColor: color } : {}">
    <div class="card-header">
      <h3 class="department-name" :style="color ? { color: color } : {}">{{ title }}</h3>
      <div class="card-actions">
        <button
          @click="$emit('edit')"
          class="btn btn-sm btn-secondary"
        >
          Edit
        </button>
        <button
          @click="$emit('delete')"
          class="btn btn-sm btn-secondary"
        >
          Delete
        </button>
      </div>
    </div>

    <div class="card-body">
      <div class="department-info">
        <div
          v-for="item in infoItems"
          :key="item.label"
          class="info-item"
        >
          <span class="info-label">{{ item.label }}:</span>
          <span class="info-value">{{ item.value }}</span>
        </div>
      </div>

      <div v-if="additionalContent" class="additional-content">
        <slot name="additional"></slot>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
interface InfoItem {
  label: string
  value: string | number
}

interface Props {
  title: string
  infoItems: InfoItem[]
  additionalContent?: boolean
  color?: string
}

interface Emits {
  (e: 'edit'): void
  (e: 'delete'): void
}

defineProps<Props>()
defineEmits<Emits>()
</script>

<style scoped>
/* Exact same styling as Department cards */
.department-card {
  background-color: white;
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-sm);
  border: 1px solid var(--color-neutral-200);
  border-left: 4px solid var(--color-neutral-200);
  overflow: hidden;
  transition: all 0.2s ease;
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
  color: var(--color-neutral-600);
  font-size: var(--font-size-sm);
}

.info-value {
  color: var(--color-neutral-900);
  font-weight: 500;
  font-size: var(--font-size-sm);
}

.additional-content {
  padding-top: var(--space-4);
  border-top: 1px solid var(--color-neutral-200);
}

/* Button styles to match the design system */
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: var(--space-2) var(--space-4);
  border: 1px solid transparent;
  border-radius: var(--radius-md);
  font-size: var(--font-size-sm);
  font-weight: 500;
  line-height: 1.5;
  text-decoration: none;
  cursor: pointer;
  transition: all 0.15s ease-in-out;
  white-space: nowrap;
}

.btn-sm {
  padding: var(--space-1) var(--space-3);
  font-size: var(--font-size-xs);
}

.btn-secondary {
  background-color: white;
  border-color: var(--color-neutral-300);
  color: var(--color-neutral-700);
}

.btn-secondary:hover {
  background-color: var(--color-neutral-50);
  border-color: var(--color-neutral-400);
  color: var(--color-neutral-900);
}

.btn-secondary:focus {
  outline: 2px solid var(--color-primary);
  outline-offset: 2px;
}

/* Responsive design */
@container (max-width: 768px) {
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
</style>
