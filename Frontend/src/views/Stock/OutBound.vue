<template>
  <el-table
    :data="results"
    border
    style="width: 100%"
    show-summary
    :summary-method="getSummaries"
    :default-sort="{ prop: 'status', order: 'descending' }"
  >
    <el-table-column type="expand" label="明细">
      <template #default="props">
        <el-table :data="props.row.receiptDetails">
          <el-table-column label="订单号" prop="receiptId" />
          <el-table-column label="产品号" prop="productId" />
          <el-table-column label="数量" prop="quantity" />
        </el-table>
      </template>
    </el-table-column>

    <el-table-column prop="id" label="ID" />
    <el-table-column prop="seller" label="销售" :formatter="cashierFormatter" width="100" />
    <el-table-column prop="date" label="日期" />
    <el-table-column prop="status" label="状态" sortable width="100">
      <template #default="scope">
        <el-tag :type="scope.row.status === 2 ? 'success' : 'info'">
          {{ status[scope.row.status - 1] }}
        </el-tag>
      </template>
    </el-table-column>
    <el-table-column prop="totalPrice" sortable label="金额" />
    <el-table-column label="操作">
      <template #default="scope">
        <el-button
          size="small"
          type="success"
          @click="handlePayment(scope.row.id)"
          v-if="scope.row.status === 2"
        >
          出库
        </el-button>
      </template>
    </el-table-column>
  </el-table>
</template>

<script lang="ts" setup>
import { ref, onMounted } from 'vue'
import service from '@/utils/request'
import Notification from '@/utils/notification'

import type { TableColumnCtx } from 'element-plus/es/components/table/src/table-column/defaults'
const status = ['新订单', '已付款', '已出库', '已完成']

const results = ref([])

const loadReceiptList = async () => {
  const response = await service.get('receipt-with-details-list')
  try {
    results.value = response.data.data
    console.log(results.value)
  } catch (error) {
    console.log(error)
  }
}

onMounted(() => loadReceiptList())

const handlePayment = async (id: string) => {
  const response = await service.post('outbound', { id: id })
  try {
    if (response.data.message === 'OK') {
      Notification({
        title: '出库成功😜',
        text: id + '已出库',
        position: 'top-right'
      })
      loadReceiptList()
    }
  } catch (error) {
    console.log(error)
  }
}

const cashierFormatter = (cellValue: any) => {
  const staff = ['倪尔', '尚若冰', '岳姗']
  return staff[cellValue.seller - 1]
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
