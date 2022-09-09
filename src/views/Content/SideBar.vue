<template>
  <el-scrollbar>
    <div id="asideMenu" class="aside-bar" :style="{ width: windowWidth }">
      <transition name="logo-fade" mode="out-in">
        <img
          src="@/assets/infoweaver/白全.svg"
          width="160"
          height="70"
          alt="logo"
          v-if="!store.isCollapse"
        />
        <img src="@/assets/infoweaver/白.svg" width="50" height="70" alt="logo" v-else />
      </transition>

      <el-menu
        active-text-color="#ffd04b"
        background-color=" #40485B"
        text-color="#fff"
        :collapse="store.isCollapse"
        :collapse-transition="false"
        :unique-opened="true"
        router
      >
        <el-sub-menu :index="subMenu.index" v-for="subMenu in menu" :key="subMenu.index">
          <template #title>
            <el-icon>
              <component :is="subMenu.icon"></component>
            </el-icon>
            <span>{{ subMenu.item }}</span>
          </template>

          <el-menu-item
            :index="menuItem.index"
            v-for="menuItem in subMenu.subMenu"
            :key="menuItem.index"
          >
            <template #title>
              <el-icon>
                <component :is="menuItem.icon"></component>
              </el-icon>
              <span>{{ menuItem.item }}</span>
            </template>
          </el-menu-item>
        </el-sub-menu>
      </el-menu>
    </div>
  </el-scrollbar>
</template>

<script lang="ts" setup>
import type { Component } from 'vue'
import { onMounted, ref, watch } from 'vue'
import {
  Menu as MenuIcon,
  Reading,
  Document,
  View,
  Setting,
  Money,
  Goods,
  Handbag,
  ShoppingCart,
  Box,
  Wallet
} from '@element-plus/icons-vue'

import { useMainStore } from '@/stores/index'

interface MenuItem {
  index: string
  item: string
  icon: Component
}

interface Menu extends MenuItem {
  subMenu: Array<MenuItem>
}

const menu: Array<Menu> = [
  {
    index: '1',
    item: '库存管理',
    icon: MenuIcon,
    subMenu: [
      { index: 'stock', item: '查看库存', icon: Reading },
      { index: 'outbound', item: '货物出库', icon: Handbag },
      { index: 'stock-taking', item: '库存盘点', icon: Box }
    ]
  },
  {
    index: '2',
    item: '账单管理',
    icon: Document,
    subMenu: [
      { index: 'cashier', item: '查看账单', icon: View },
      { index: 'payment', item: '支付账单', icon: Money },
      { index: 'money-taking', item: '现金盘点', icon: Wallet }
    ]
  },
  {
    index: '3',
    item: '销售管理',
    icon: Setting,
    subMenu: [
      { index: 'sales', item: '销售状况', icon: Goods },
      { index: 'receipt', item: '开具小票', icon: ShoppingCart }
    ]
  }
]

const store = useMainStore()
const windowWidth = ref('200px')

watch(
  () => store.isCollapse,
  (width) => {
    windowWidth.value = width ? '55px' : '200px'
  }
)

onMounted(() => {
  if (window.innerWidth < 700) {
    windowWidth.value = '55px'
    store.changeCollapseState()
  }
})

window.addEventListener('resize', () => {
  if (window.innerWidth < 700) {
    if (!store.isCollapse) {
      store.changeCollapseState()
      windowWidth.value = '55px'
    }
  } else {
    if (store.isCollapse) {
      store.changeCollapseState()
      windowWidth.value = '200px'
    }
  }
})
</script>

<style lang="scss" scoped>
$aside-color: #40485b;

.aside-bar {
  width: 200px;
  height: 100vh;
  min-width: 55px;
  padding: 0 !important;
  margin: 0 !important;
  color: var(--el-text-color-primary);
  background-color: $aside-color;
  transition: width 0.6s;

  .el-menu {
    width: 100%;
    border: none;

    .el-sub-menu {
      .el-menu-item {
        min-width: 100%;
      }
    }
  }

  .el-menu--collapse {
    :deep(.el-sub-menu__title) {
      padding-left: 15px;
    }
  }
}

.logo-fade-enter-from {
  opacity: 0;
}

.logo-fade-enter-active {
  transition: opacity 0.5s ease;
}

.logo-fade-leave-to {
  opacity: 0;
}

.logo-fade-leave-active {
  transition: opacity 0.3s ease;
}
</style>
