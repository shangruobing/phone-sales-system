<template>
  <div>
    <el-row>
      <el-col :span="12">
        <el-upload
          ref="upload"
          :auto-upload="false"
          :http-request="readCsv"
          :limit="1"
          :multiple="false"
          :on-change="readCsv"
          :show-file-list="false"
          accept=".csv"
          action="Fake Action"
          :on-exceed="handleExceed"
        >
          <template #trigger>
            <el-button type="primary">选择文件</el-button>
          </template>
          <template #tip>
            <div class="el-upload__tip">上传一个CSV文件</div>
          </template>
        </el-upload>
      </el-col>
      <el-col :span="12">
        <el-button type="primary" @click="enterBound">确认入库</el-button>
      </el-col>
    </el-row>
    <el-table
      :data="results"
      stripe
      border
      style="width: 100%"
      :default-sort="{ prop: 'date', order: 'descending' }"
    >
      <el-table-column prop="id" label="序列号" />
      <el-table-column prop="brand" label="品牌" />
      <el-table-column prop="model" label="型号" />
      <el-table-column prop="type" label="类型" />
      <el-table-column prop="quantity" label="库存数量" sortable />
    </el-table>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import service from '@/utils/request'
import Notification from '@/utils/notification'
import { genFileId } from 'element-plus'
import type { UploadInstance, UploadProps, UploadRawFile } from 'element-plus'

interface Product {
  id: string
  name: string
  model: string
  type: string
  price: number
  quantity: number
}

const results = ref<Array<Product>>([])
const upload = ref<UploadInstance>()

const readCsv = (file: any, fileList: any) => {
  const reader = new FileReader()
  reader.readAsText(file.raw, 'UTF-8')
  reader.onload = function (evt) {
    const fileString = evt.target!.result as any
    results.value = csvToArray(fileString)
  }
}

const csvToArray = (raw: string, delimiter = ',') => {
  console.log(raw)
  const headers = raw
    .slice(0, raw.indexOf('\n'))
    .split(delimiter)
    .map((e) => e.trim())
  console.log(headers)

  const rows = raw
    .slice(raw.indexOf('\n') + 1)
    .split('\n')
    .filter((e) => e !== '')
    .map((e) => e.trim())
  console.log(rows)

  return rows.map((row) => {
    const values = row.split(delimiter)
    return headers.reduce((object: any, header, index) => {
      object[header] = values[index]
      return object
    }, {})
  })
}

interface StockAccount {
  employeeId: string
  productId: string
  quantity: number
}

const enterBound = async () => {
  try {
    console.log(results.value)
    console.table(results.value)

    let response = await service.post('check-product', results.value)

    const data: Array<StockAccount> = []

    results.value.forEach((e) => {
      const { id, quantity } = e
      data.push({
        employeeId: '1',
        productId: id,
        quantity: quantity
      })
    })
    console.log(data)

    response = await service.post(
      'enter-stock',
      data.filter((e) => e.productId !== undefined)
    )

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

const handleExceed: UploadProps['onExceed'] = (files) => {
  upload.value!.clearFiles()
  const file = files[0] as UploadRawFile
  file.uid = genFileId()
  upload.value!.handleStart(file)
}
</script>

<style>
.el-row {
  width: 100%;
  margin-bottom: 20px;
}
</style>
