import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/Home.vue'

const routes = [
    {
        path: '/',
        name: 'home',
        component: HomeView
    },
    {
        path: '/tos',
        name: 'Terms of Service',
        component: () => import(/* webpackChunkName: "about" */ '../views/ToS.vue')
    },
    {
        path: '/privacy-policy',
        name: 'Privacy Policy',
        // route level code-splitting
        // this generates a separate chunk (about.[hash].js) for this route
        // which is lazy-loaded when the route is visited.
        component: () => import(/* webpackChunkName: "about" */ '../views/PrivacyPolicy.vue')
    },
    {
        path: '/deletion-request',
        name: 'Deletion Request',
        component: () => import(/* webpackChunkName: "about" */ '../views/DeletionRequest.vue')
    },
    // Route to profile page which takes in a user ID URL parameter
    {
        path: '/profile/:id',
        name: 'profile',
        component: () => import(/* webpackChunkName: "profile" */ '../views/Profile.vue')
    },
]

const router = createRouter({
    history: createWebHistory(process.env.BASE_URL),
    routes
})

export default router
