<template>
  <div class="main-pan">
    <h1 style="font-size: 1.5em">欢迎来到手机销售系统</h1>
    <h2>Mobile Phone Sales System</h2>
    <h3>信息管理与信息系统191 短学期 Ⅲ</h3>
    <h4>
      为我们打分！
      <el-rate v-model="rate" @click="thanks" />
    </h4>
  </div>
</template>

<script lang="ts" setup>
import { ref } from 'vue'
import 'element-plus/theme-chalk/display.css'
import Notification from '@/utils/notification'

const rate = ref(null)

const thanks = () => {
  Notification({
    title: '谢谢评分😜',
    text: '我们会继续努力的',
    position: 'top-left'
  })
}
</script>

<style lang="scss" scoped>
.main-pan {
  padding-bottom: 1em;
  margin: 0;
  margin-top: 1em;
  text-align: center;
  background-color: #f2f4f5;
}
</style>
