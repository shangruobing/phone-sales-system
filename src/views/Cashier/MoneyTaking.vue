<template>
  <div>
    <el-table
      :data="results"
      :model="results"
      stripe
      border
      style="width: 100%"
      :default-sort="{ prop: 'date', order: 'descending' }"
      show-summary
      :summary-method="getSummaries"
    >
      <el-table-column prop="date" label="账户变动时间" :formatter="formatter" />
      <el-table-column prop="beginningBalance" label="月初金额" width="150" />
      <el-table-column prop="endingBalance" label="月末金额" width="150" />

      <el-table-column prop="totalPrice" label="盘点数量" sortable width="150">
        <template #default="scope">
          <el-input v-model.number="scope.row.totalPrice" size="small"></el-input>
        </template>
      </el-table-column>
      <el-table-column prop="balance" label="差额" sortable width="150">
        <template #default="scope">
          {{ scope.row.totalPrice - scope.row.endingBalance }}
        </template>
      </el-table-column>
      <el-table-column prop="note" label="备注" width="250">
        <template #default="scope">
          <el-input v-model="scope.row.note" size="small"></el-input>
        </template>
      </el-table-column>
    </el-table>
    <el-divider />
    <el-row :gutter="20">
      <el-col :span="12">
        <el-button type="primary">保 存</el-button>
      </el-col>
      <el-col :span="12">
        <el-button type="primary" @click="submitForm">提 交</el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script lang="ts" setup>
import { ref, onMounted } from 'vue'
import type { TableColumnCtx } from 'element-plus/es/components/table/src/table-column/defaults'
import service from '@/utils/request'
import Notification from '@/utils/notification'

const results = ref([])

const submitForm = async () => {
  try {
    const { employeeId, totalPrice, note } = results.value[0]
    const data = { employeeId, totalPrice, note }
    await service.post('money-taking', data)
    Notification({
      title: '提交成功🎉',
      text: '现金信息已更新',
      position: 'top-right'
    })
    loadMoneyList()
  } catch (error) {
    console.log(error)
  }
}

onMounted(async () => {
  loadMoneyList()
})

const loadMoneyList = async () => {
  try {
    const response = await service.get('money-taking')
    results.value = response.data.data
    console.log(results.value)
  } catch (error) {
    console.log(error)
  }
}

const formatter = (row: any) => {
  return row.date.split(' ')[0]
}

interface MoneyList {
  [key: string]: any
  id: string
  date: string
  beginningBalance: number
  endingBalance: number
  totalPrice: number
}

interface SummaryMethodProps<T = MoneyList> {
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
    if (['beginningBalance', 'endingBalance', 'balance'].indexOf(column.property) !== -1) {
      sums[index] = `${values.reduce((prev, curr) => {
        const value = Number(curr)
        if (!Number.isNaN(value)) {
          return prev + curr
        } else {
          return prev
        }
      }, 0)}元`
    } else {
      sums[index] = ''
    }
  })

  return sums
}
</script>

<style scoped>
.el-row {
  margin-bottom: 15px;
}

.el-col {
  border-radius: 4px;
}
</style>
