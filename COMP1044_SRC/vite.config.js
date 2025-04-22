import { fileURLToPath, URL } from 'node:url'
import path from 'path'

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import vueDevTools from 'vite-plugin-vue-devtools'

import tailwindcss from "@tailwindcss/vite";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    vue(),
    vueDevTools(),
    tailwindcss(),
  ],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
  base: '/CRM/COMP1044_SRC/dist/',
  build: {
    outDir: 'dist',
    assetsDir: 'assets',
    emptyOutDir: true
  },
  /*
  // specify what the output html file will be named
  build: {
    rollupOptions: {
      input: {
        app: "uwucrm_abb.html",
      }
    }
  },
  // specify which html file to open by the server
  server: {
    open: "/uwucrm_abb.html"
  },
  */
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost/COMP1044_SRC/backend',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api/, '')
      }
    }
  }
})
