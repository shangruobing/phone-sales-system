<template>
  <div>
    <el-row>
      <el-col :span="12">
        <el-input
          v-model="brand"
          type="text"
          placeholder="请输入品牌名称"
          style="width: 50%"
          :suffix-icon="Search"
          @change="handleBrandChange"
        />
      </el-col>
      <el-col :span="12">
        <el-input
          v-model="model"
          type="text"
          placeholder="请输入配置"
          style="width: 50%"
          :suffix-icon="Search"
          @change="handleModelChange"
        />
      </el-col>
    </el-row>
    <el-table
      :data="results"
      stripe
      border
      style="width: 100%"
      :default-sort="{ prop: 'date', order: 'descending' }"
      show-summary
      :summary-method="getSummaries"
    >
      <el-table-column prop="product.id" label="序列号" />
      <el-table-column prop="product.brand" label="品牌" />
      <el-table-column prop="product.model" label="型号" />
      <el-table-column prop="product.type" label="类型" />
      <el-table-column prop="quantity" label="库存数量" sortable />
    </el-table>
  </div>
</template>

<script lang="ts" setup>
import { ref, onMounted } from 'vue'
import { Search } from '@element-plus/icons-vue'
import type { TableColumnCtx } from 'element-plus/es/components/table/src/table-column/defaults'
import service from '@/utils/request'

const brand = ref('')
const model = ref('')
const results = ref([])

onMounted(async () => {
  const response = await service.get('stock-account')
  try {
    results.value = response.data.data
  } catch (error) {
    console.log(error)
  }
})

const handleBrandChange = async () => {
  let api = 'stock-account/'
  if (model.value === '') {
    api = 'stock-account/?brand=' + brand.value
  } else {
    api = 'stock-account/?brand=' + brand.value + '&model=' + model.value
  }
  try {
    const response = await service.get(api)
    results.value = response.data.data
  } catch (error) {
    console.log(error)
  }
}

const handleModelChange = async () => {
  let api = 'stock-account/'
  if (brand.value === '') {
    api = 'stock-account/?model=' + model.value
  } else {
    api = 'stock-account/?brand=' + brand.value + '&model=' + model.value
  }
  try {
    const response = await service.get(api)
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
    if (column.property === 'quantity') {
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
