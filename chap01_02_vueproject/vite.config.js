import { fileURLToPath, URL } from 'node:url'

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import vueDevTools from 'vite-plugin-vue-devtools'

// https://vite.dev/config/
export default defineConfig({
  plugins: [
    vue(),
    vueDevTools(),
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    },
  },
  // server: {
  //   proxy: {
  //     '/api': {
  //       /* 백엔드가 컨테이너화 되기 전 */
  //       // target: 'http://localhost:7777',

  //       /* 백엔드가 컨테이너화 된 후 */
  //       // target: 'http://localhost:8055',

  //       /* docker-compose 이후 도커 네트워크 활용 
  //       컨테이너 이름으로 접근 해야 함 */
  //       target: 'http://springboot-app:7777',
  //       changeOrigin: true,
  //       rewrite:(path) => path.replace(/^\/api/, '')
  //     }
  //   }
  // }
})
