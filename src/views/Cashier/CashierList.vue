<template>
  <el-table :data="results" border style="width: 100%" show-summary :summary-method="getSummaries">
    <el-table-column prop="id" label="ID" />
    <el-table-column prop="employeeId" label="操作员" :formatter="cashierFormatter" width="100" />
    <el-table-column prop="date" label="日期" />
    <el-table-column prop="receiptId" label="小票号" />
    <el-table-column prop="total" sortable label="金额" />
  </el-table>
</template>

<script lang="ts" setup>
import { ref, onMounted } from 'vue'
import service from '@/utils/request'
import type { TableColumnCtx } from 'element-plus/es/components/table/src/table-column/defaults'

const results = ref([])

onMounted(async () => {
  const response = await service.get('/money-account')
  try {
    results.value = response.data.data
    console.log(results.value)
  } catch (error) {
    console.log(error)
  }
})

const cashierFormatter = (cellValue: any) => {
  const staff = ['倪尔', '尚若冰', '岳姗']
  return staff[cellValue.employeeId - 1]
}

interface CashierList {
  [key: string]: any
  id: string
  employeeId: string
  date: string
  receiptId: string
  total: number
}

interface SummaryMethodProps<T = CashierList> {
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
    if (column.property === 'total') {
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
