import { fileURLToPath, URL } from 'node:url'

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import vueDevTools from 'vite-plugin-vue-devtools'

import tailwindcss from "@tailwindcss/vite";

// https://vite.dev/config/
export default defineConfig({
  plugins: [
    vue(),
    vueDevTools(),
    tailwindcss(),
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    },
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
  base: "",
})
