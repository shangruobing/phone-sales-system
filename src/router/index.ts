import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router'

declare module 'vue-router' {
  export interface RouteMeta {
    title?: string
    props?: never
  }
}

const routes: Array<RouteRecordRaw> = [
  {
    path: '/',
    name: 'home',
    meta: { title: '首页' },
    component: () => import('../views/Home/Index.vue')
  },
  {
    path: '/content/',
    name: 'content',
    meta: { title: '后台' },
    component: () => import('../views/Content/Index.vue'),
    children: [
      {
        path: '',
        name: 'welcome',
        meta: { title: '家' },
        component: () => import('../views/Content/Welcome.vue')
      },
      {
        path: 'stock',
        meta: { subMenu: '库存管理', menuItem: '查看库存' },
        component: () => import('../views/Stock/StockList.vue')
      },
      {
        path: 'outbound',
        meta: { subMenu: '库存管理', menuItem: '货物出库' },
        component: () => import('../views/Stock/OutBound.vue')
      },
      {
        path: 'stock-taking',
        meta: { subMenu: '库存管理', menuItem: '库存盘点' },
        component: () => import('../views/Stock/StockTaking.vue')
      },
      {
        path: 'cashier',
        meta: { subMenu: '出纳管理', menuItem: '查看账单' },
        component: () => import('../views/Cashier/CashierList.vue')
      },
      {
        path: 'payment',
        meta: { subMenu: '出纳管理', menuItem: '支付账单' },
        component: () => import('../views/Cashier/Payment.vue')
      },
      {
        path: 'money-taking',
        meta: { subMenu: '出纳管理', menuItem: '现金盘点' },
        component: () => import('../views/Cashier/MoneyTaking.vue')
      },
      {
        path: 'sales',
        meta: { subMenu: '销售管理', menuItem: '销售状况' },
        component: () => import('../views/Sales/SalesList.vue')
      },
      {
        path: 'receipt',
        meta: { subMenu: '销售管理', menuItem: '开具小票' },
        component: () => import('../views/Sales/SaveReceipt.vue')
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  strict: true
})

export default router
