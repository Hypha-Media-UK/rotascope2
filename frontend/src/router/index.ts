import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView,
    },
    {
      path: '/configure',
      name: 'configure',
      component: () => import('../views/ConfigureView.vue'),
    },
    {
      path: '/configure/departments',
      name: 'configure-departments',
      component: () => import('../views/ConfigureView.vue'),
      props: { activeTab: 'departments' }
    },
    {
      path: '/configure/porters',
      name: 'configure-porters',
      component: () => import('../views/ConfigureView.vue'),
      props: { activeTab: 'porters' }
    },
    {
      path: '/configure/shifts',
      name: 'configure-shifts',
      component: () => import('../views/ConfigureView.vue'),
      props: { activeTab: 'shifts' }
    },
  ],
})

export default router
