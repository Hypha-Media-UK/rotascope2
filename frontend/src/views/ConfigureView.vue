<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import DepartmentManager from '@/components/DepartmentManager.vue'
import PorterManager from '@/components/PorterManager.vue'
import ShiftManager from '@/components/ShiftManager.vue'

// Props
interface Props {
  activeTab?: string
}

const props = withDefaults(defineProps<Props>(), {
  activeTab: 'departments'
})

// State
const route = useRoute()
const currentTab = ref(props.activeTab)

// Computed
const tabs = computed(() => [
  {
    id: 'departments',
    label: 'Departments',
    description: 'Manage departments and their operational hours'
  },
  {
    id: 'porters',
    label: 'Porters',
    description: 'Manage porter details and contracted hours'
  },
  {
    id: 'shifts',
    label: 'Shifts',
    description: 'Create and manage shift patterns'
  }
])

// Methods
function setActiveTab(tabId: string) {
  currentTab.value = tabId
}

// Lifecycle
onMounted(() => {
  // Set tab from route if provided
  if (route.params.tab) {
    currentTab.value = route.params.tab as string
  }
})
</script>

<template>
  <div class="configure-view">
    <!-- Page Header -->
    <div class="page-header">
      <div class="page-title-section">
        <h1 class="page-title">Configuration</h1>
        <p class="page-subtitle">Manage departments, porters, and shifts</p>
      </div>
    </div>

    <!-- Tab Navigation -->
    <div class="tab-nav">
      <div class="tab-list">
        <button
          v-for="tab in tabs"
          :key="tab.id"
          @click="setActiveTab(tab.id)"
          class="tab-button"
          :class="{ 'tab-button--active': currentTab === tab.id }"
        >
          <span class="tab-label">{{ tab.label }}</span>
          <span class="tab-description">{{ tab.description }}</span>
        </button>
      </div>
    </div>

    <!-- Tab Content -->
    <div class="tab-content">
      <div v-if="currentTab === 'departments'" class="tab-panel">
        <DepartmentManager />
      </div>
      
      <div v-if="currentTab === 'porters'" class="tab-panel">
        <PorterManager />
      </div>
      
      <div v-if="currentTab === 'shifts'" class="tab-panel">
        <ShiftManager />
      </div>
    </div>
  </div>
</template>

<style scoped>
.configure-view {
  container-type: inline-size;
}

.page-header {
  margin-bottom: var(--space-8);
  padding-bottom: var(--space-6);
  border-bottom: 1px solid var(--color-neutral-200);
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

.tab-nav {
  margin-bottom: var(--space-8);
}

.tab-list {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: var(--space-4);
}

@container (max-width: 768px) {
  .tab-list {
    grid-template-columns: 1fr;
  }
}

.tab-button {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  padding: var(--space-6);
  border: 1px solid var(--color-neutral-200);
  border-radius: var(--radius-lg);
  background-color: white;
  cursor: pointer;
  transition: all 0.2s ease;
  text-align: left;
}

.tab-button:hover {
  border-color: var(--color-primary);
  box-shadow: var(--shadow-sm);
}

.tab-button--active {
  border-color: var(--color-primary);
  background-color: rgb(37 99 235 / 0.05);
  box-shadow: var(--shadow-md);
}

.tab-label {
  font-size: var(--font-size-lg);
  font-weight: 600;
  color: var(--color-neutral-900);
  margin-bottom: var(--space-2);
}

.tab-button--active .tab-label {
  color: var(--color-primary);
}

.tab-description {
  font-size: var(--font-size-sm);
  color: var(--color-neutral-600);
  line-height: 1.5;
}

.tab-content {
  min-height: 400px;
}

.tab-panel {
  animation: fadeIn 0.2s ease-in-out;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
