<template>
  <div class="containter">
    <el-form :model="form" status-icon ref="formRef" label-width="120px">
      <el-row :gutter="5" class="header-pan">
        <el-col :span="12">
          <el-form-item prop="date" label="入库日期">
            <el-date-picker v-model="form.date" type="date" placeholder="勾选一个日期" />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item prop="cashier" label="库管员">
            <el-select v-model="form.cashier" placeholder="Select">
              <el-option
                v-for="item in employee"
                :key="item.value"
                :label="item.label"
                :value="item.value"
              />
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>

      <el-divider />

      <el-row :gutter="10" v-for="(item, index) in form.items" :key="item">
        <el-row>
          <el-col :span="8">
            <el-form-item
              :label="'项目号' + (index + 1)"
              prop="'name' + index"
              class="product-item"
            >
              <el-select
                v-model="item.name"
                placeholder="Select"
                @change="handleSelect(index, item.name)"
              >
                <el-option
                  v-for="item in stockList"
                  :key="item.product.name"
                  :label="item.product.name"
                  :value="item.product.name"
                />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="序列号" prop="productId" class="price-item">
              <el-input v-model="item.productId" disabled />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="现有数量" prop="'kept" class="price-item">
              <el-input v-model="item.kept" disabled />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="8">
            <el-form-item label="入库数量" prop="'quantity' + index" class="price-item">
              <el-input-number
                v-model="item.quantity"
                :min="1"
                :max="500"
                @change="handleQuantityChange(index, item.name)"
              />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="备 注" prop="note" class="price-item">
              <el-input type="text" v-model="item.note" autocomplete="off" maxlength="50" />
            </el-form-item>
          </el-col>

          <el-col :span="8">
            <el-button @click.prevent="removeProductItem(item)">删除行</el-button>
          </el-col>
        </el-row>
      </el-row>
      <el-divider />
      <el-row :gutter="20">
        <el-col :span="4" :offset="4">
          <el-form-item>
            <el-button type="primary" @click="addProductItem">新增行</el-button>
          </el-form-item>
        </el-col>
        <el-col :span="4" :offset="4">
          <el-form-item>
            <el-button type="primary" @click="submitForm">提 交</el-button>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref, onMounted } from 'vue'
import service from '@/utils/request'
import Notification from '@/utils/notification'

const stockList = reactive([
  {
    id: '12345',
    productId: '1',
    employeeId: '1',
    date: 1662220800000,
    quantity: 2,
    kept: 2,
    note: '库存充足',
    product: {
      id: '1',
      brand: '小米',
      type: 'CC9 Pro',
      model: '8G/256G',
      price: 2999,
      name: '小米 CC9 Pro 8G/256G'
    }
  }
])

onMounted(async () => {
  const response = await service.get('stock-account')
  response.data.data.forEach((e: any) => stockList.push(e))
  console.log(stockList)
})

const employee = [
  {
    value: '1',
    label: '倪尔'
  },
  {
    value: '2',
    label: '尚若冰'
  },
  {
    value: '3',
    label: '岳姗'
  }
]

interface ProductItem {
  productId: string
  name: string
  quantity: number
  kept: number
  note: string
}

const formRef = ref(null)
const form = reactive<{
  date: number
  seller: string
  cashier: string
  items: ProductItem[]
}>({
  date: Date.now(),
  seller: '岳姗',
  cashier: '倪尔',
  items: [
    {
      productId: '1',
      name: '小米 CC9 Pro 8G/256G',
      quantity: 1,
      kept: 1,
      note: '库存充足'
    }
  ]
})

const addProductItem = () => {
  form.items.push({
    productId: '1',
    name: '小米 CC9 Pro 8G/256G',
    quantity: 1,
    kept: 1,
    note: '库存充足'
  })
}

const removeProductItem = (item: any) => {
  const index = form.items.indexOf(item)
  if (index !== -1) {
    form.items.splice(index, 1)
  }
}

interface Data {
  employeeId: string
  productId: string
  quantity: number
}

const submitForm = async () => {
  const data: Array<Data> = []

  form.items.forEach((e) => {
    data.push({ employeeId: '1', productId: e.productId, quantity: e.quantity })
  })

  try {
    const response = await service.post('enter-stock', data)
    console.log('response', response)
    Notification({
      title: '提交成功🎉',
      text: '已完成上述产品的入库',
      position: 'top-right'
    })
  } catch (error) {
    console.log(error)
  }
}

const handleSelect = (index: number, obj: string) => {
  stockList.forEach((e) => {
    if (e.product.name === obj) {
      form.items[index].productId = e.product.id
      form.items[index].kept = e.kept
      form.items[index].note = e.note
    }
  })
}

const handleQuantityChange = (index: number, obj: string) => {
  stockList.forEach((e) => {
    if (e.product.name === obj) {
      form.items[index].productId = e.product.id
    }
  })
}
</script>

<style>
.containter {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 30px;
}

.el-form {
  margin: auto;
  border: 1px solid var(--el-border-color);
  border-radius: 0;
}

.el-col {
  height: 45px;
}

.el-row {
  width: 100%;
}

.header-pan {
  margin-top: 20px;
}

.price-item {
  width: 300px;
}

.product-item {
  width: 400px;
}
</style>
