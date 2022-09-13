import { createApp } from 'vue'
import App from './App.vue'

import 'default-passive-events'
import 'element-plus/dist/index.css'
import ElementPlus from 'element-plus'
import zhCn from 'element-plus/es/locale/lang/zh-cn'

import { createPinia } from 'pinia'
import router from './router/index'
import '@/styles/index.scss'

const app = createApp(App)

const pinia = createPinia()
app.use(ElementPlus, { locale: zhCn })
app.use(router)
app.use(pinia)
app.mount('#app')
