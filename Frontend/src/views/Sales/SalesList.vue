<template>
  <el-table :data="results" border style="width: 100%" show-summary :summary-method="getSummaries">
    <el-table-column prop="id" label="ID" />
    <el-table-column prop="seller" label="销售" :formatter="sellerFormatter" width="100" />
    <el-table-column prop="cashier" label="出纳" :formatter="cashierFormatter" width="100" />
    <el-table-column prop="date" label="日期" />
    <el-table-column prop="status" label="备注" :formatter="orderFormatter" />
    <el-table-column prop="totalPrice" sortable label="金额" />
  </el-table>
</template>

<script lang="ts" setup>
import { ref, onMounted } from 'vue'
import type { TableColumnCtx } from 'element-plus/es/components/table/src/table-column/defaults'

import service from '@/utils/request'

const results = ref([])

onMounted(async () => {
  const response = await service.get('/receipt-with-details-list/')
  try {
    results.value = response.data.data
    console.log(results.value)
  } catch (error) {
    console.log(error)
  }
})

const sellerFormatter = (cellValue: any) => {
  const staff = ['倪尔', '尚若冰', '岳姗']
  return staff[cellValue.seller - 1]
}

const cashierFormatter = (cellValue: any) => {
  const staff = ['倪尔', '尚若冰', '岳姗']
  return staff[cellValue.cashier - 1]
}

const orderFormatter = (cellValue: any) => {
  const status = ['新订单', '已付款', '已出库', '已完成']
  return status[cellValue.status - 1]
}

interface SalesList {
  [key: string]: any
  id: string
  seller: string
  cashier: string
  date: string
  status: string
  total: number
}

interface SummaryMethodProps<T = SalesList> {
  [key: string]: string | unknown
  columns: TableColumnCtx<T>[]
  data: T[]
}

const getSummaries = (param: SummaryMethodProps) => {
  const { columns, data } = param
  const sums: string[] = []
  columns.forEach((column, index) => {
    if (index === 0) {
      sums[index] = '合计'
      return
    }
    const values = data.map((item) => Number(item[column.property]))
    if (column.property === 'totalPrice') {
      sums[index] = `￥ ${values.reduce((prev, curr) => {
        const value = Number(curr)
        if (!Number.isNaN(value)) {
          return prev + curr
        } else {
          return prev
        }
      }, 0)}`
    } else {
      sums[index] = ''
    }
  })

  return sums
}
</script>
