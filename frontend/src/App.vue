<script setup lang="ts">
import { RouterLink, RouterView } from 'vue-router'
</script>

<template>
  <div id="app">
    <!-- Header Navigation -->
    <header class="header">
      <div class="header-content">
        <div class="header-brand">
          <h1 class="brand-title">Rotascope</h1>
          <p class="brand-subtitle">Porter Tracking System</p>
        </div>

        <nav class="nav">
          <RouterLink to="/" class="nav-link">
            Home
          </RouterLink>
          <RouterLink to="/configure" class="nav-link">
            Configure
          </RouterLink>
        </nav>
      </div>
    </header>

    <!-- Main Content -->
    <main class="main">
      <RouterView />
    </main>

    <!-- Footer -->
    <footer class="footer">
      <div class="footer-content">
        <p class="text-sm text-neutral-500">
          © 2025 Rotascope - Porter Tracking System
        </p>
      </div>
    </footer>
  </div>
</template>

<style scoped>
.header {
  background-color: white;
  border-bottom: 1px solid var(--color-neutral-200);
  box-shadow: var(--shadow-sm);
}

.header-content {
  width: 100%;
  max-width: 1400px;
  margin: 0 auto;
  padding: var(--space-4) var(--space-6);
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.header-brand {
  display: flex;
  flex-direction: column;
}

.brand-title {
  font-size: var(--font-size-2xl);
  font-weight: 700;
  color: var(--color-neutral-900);
  margin: 0;
  line-height: 1.2;
}

.brand-subtitle {
  font-size: var(--font-size-sm);
  color: var(--color-neutral-500);
  margin: 0;
  line-height: 1.2;
}

.nav {
  display: flex;
  gap: var(--space-6);
}

.nav-link {
  font-size: var(--font-size-base);
  font-weight: 500;
  color: var(--color-neutral-600);
  text-decoration: none;
  padding: var(--space-2) var(--space-3);
  border-radius: var(--radius-md);
  transition: all 0.2s ease;
}

.nav-link:hover {
  color: var(--color-primary);
  background-color: var(--color-neutral-50);
}

.nav-link.router-link-active {
  color: var(--color-primary);
  background-color: rgb(37 99 235 / 0.1);
}

.main {
  flex: 1;
  width: 100%;
  max-width: 1400px;
  margin: 0 auto;
  padding: var(--space-8) var(--space-6);
  container-type: inline-size;
}

.footer {
  background-color: var(--color-neutral-50);
  border-top: 1px solid var(--color-neutral-200);
  margin-top: auto;
}

.footer-content {
  width: 100%;
  max-width: 1400px;
  margin: 0 auto;
  padding: var(--space-4) var(--space-6);
  text-align: center;
}

/* Responsive adjustments */
@container (max-width: 768px) {
  .header-content {
    flex-direction: column;
    gap: var(--space-4);
    text-align: center;
  }

  .nav {
    justify-content: center;
  }
}
</style>
