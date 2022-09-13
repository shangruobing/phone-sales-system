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
      <el-table-column prop="product.id" label="序列号" />
      <el-table-column prop="product.name" label="名称" />
      <el-table-column prop="quantity" label="库存数量" sortable width="100" />
      <el-table-column prop="kept" label="盘点数量" sortable width="100">
        <template #default="scope">
          <el-input v-model.number="scope.row.kept" size="small"></el-input>
        </template>
      </el-table-column>
      <el-table-column prop="balance" label="差额" sortable width="100">
        <template #default="scope">
          {{ scope.row.kept - scope.row.quantity }}
        </template>
      </el-table-column>
      <el-table-column prop="note" label="备注">
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
    await service.post('stock-taking', results.value)
    Notification({
      title: '提交成功🎉',
      text: '库存信息已更新',
      position: 'top-right'
    })
    loadStockList()
  } catch (error) {
    console.log(error)
  }
}

onMounted(async () => {
  loadStockList()
})

const loadStockList = async () => {
  try {
    const response = await service.get('stock-account')
    console.log(response)
    results.value = response.data.data
  } catch (error) {
    console.log(error)
  }
}

interface StockList {
  [key: string]: any
  id: string
  date: string
  brand: string
  type: string
  model: string
  quantity: number
}

interface SummaryMethodProps<T = StockList> {
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
    if (['quantity', 'kept', 'balance'].indexOf(column.property) !== -1) {
      sums[index] = `${values.reduce((prev, curr) => {
        const value = Number(curr)
        if (!Number.isNaN(value)) {
          return prev + curr
        } else {
          return prev
        }
      }, 0)} 件`
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
