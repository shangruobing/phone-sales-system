<template>
  <div class="containter">
    <el-form :model="form" status-icon ref="formRef" label-width="120px">
      <el-row :gutter="5" class="header-pan">
        <el-col :span="6">
          <el-form-item prop="date" label="交易日期">
            <el-date-picker v-model="form.date" type="date" placeholder="勾选一个日期" />
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item prop="seller" label="销售员">
            <el-select v-model="form.seller" placeholder="Select">
              <el-option
                v-for="item in employee"
                :key="item.value"
                :label="item.label"
                :value="item.value"
              />
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item prop="cashier" label="收纳员">
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

        <el-col :span="6">
          <el-form-item prop="amount" label="合计" class="price-item">
            <el-input v-model="form.amount" disabled />
          </el-form-item>
        </el-col>
      </el-row>

      <el-divider />

      <el-row :gutter="10" v-for="(item, index) in form.items" :key="item">
        <el-col :span="8">
          <el-form-item :label="'项目' + (index + 1)" prop="'name' + index" class="product-item">
            <el-select
              v-model="item.name"
              placeholder="Select"
              @change="handleSelect(index, item.name)"
              class="product-item"
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

        <el-col :span="4">
          <el-form-item label="价格" prop="'price' + index" class="price-item">
            <el-input v-model="item.price" disabled />
          </el-form-item>
        </el-col>
        <el-col :span="4">
          <el-form-item label="数量" prop="'quantity' + index" class="price-item">
            <el-input-number
              v-model="item.quantity"
              :min="1"
              :max="100"
              @change="handleQuantityChange(index, item.name)"
            />
          </el-form-item>
        </el-col>
        <el-col :span="4">
          <el-form-item label="合计" prop="'total' + index" class="price-item">
            <el-input type="text" v-model="item.total" autocomplete="off" maxlength="50" disabled>
            </el-input>
          </el-form-item>
        </el-col>

        <el-col :span="4">
          <el-button @click.prevent="removeProductItem(item)">删除行</el-button>
        </el-col>
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
import { toRaw } from '@vue/reactivity'
import service from '@/utils/request'
import Notification from '@/utils/notification'

const stockList = reactive([
  {
    id: '12345',
    productId: '1',
    employeeId: '1',
    date: 1662220800000,
    quantity: 2,
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
  console.log(response)
  response.data.data.forEach((e: any) => stockList.push(e))
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
  price: number
  total: number
}

const formRef = ref(null)
const form = reactive<{
  date: number
  seller: string
  cashier: string
  amount: number
  items: ProductItem[]
}>({
  date: Date.now(),
  seller: '岳姗',
  cashier: '尚若冰',
  amount: 3000,
  items: [
    {
      productId: '1',
      name: '小米 CC9 Pro 8G/256G',
      quantity: 1,
      price: 2999,
      total: 2999
    }
  ]
})

const addProductItem = () => {
  form.items.push({
    productId: '1',
    name: '小米 CC9 Pro 8G/256G',
    quantity: 1,
    price: 2999,
    total: 2999
  })
  calculateAmount()
}

const removeProductItem = (item: any) => {
  const index = form.items.indexOf(item)
  if (index !== -1) {
    form.items.splice(index, 1)
  }
}

const submitForm = async () => {
  const data: { [k: string]: any } = { ...form }
  data.receiptDetails = toRaw(data.items)
  delete data.items
  delete data.date
  employee.forEach((e) => {
    if (e.label === data.seller) data.seller = e.value
    if (e.label === data.cashier) data.cashier = e.value
  })
  console.log(data)
  try {
    const response = await service.post('receipt-with-details', data)
    Notification({
      title: '提交成功🎉',
      text: '订单号' + response.data.data,
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
      form.items[index].price = e.product.price
      form.items[index].total = e.product.price * form.items[index].quantity
    }
  })
  calculateAmount()
}

const handleQuantityChange = (index: number, obj: string) => {
  stockList.forEach((e) => {
    if (e.product.name === obj) {
      form.items[index].productId = e.product.id
      form.items[index].total = e.product.price * form.items[index].quantity
    }
  })
  calculateAmount()
}

const calculateAmount = () => {
  let amount = 0
  form.items.forEach((e) => {
    amount += e.total
  })
  form.amount = amount
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

.header-pan {
  margin-top: 20px;
}

.price-item {
  width: 220px;
}

.product-item {
  width: 400px;
}
</style>
