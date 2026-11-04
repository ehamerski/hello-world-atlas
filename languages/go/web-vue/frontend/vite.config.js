// vite.config.js - Go web-vue (frontend): settings for Vite, the tool that
// serves the Vue front end in development (npm run dev), builds it into
// plain HTML/JS files (npm run build -> dist/) and serves that build
// (npm run preview).
// Reference: https://vite.dev/config/

import vue from '@vitejs/plugin-vue'
import { defineConfig } from 'vite'

// Where the Go API listens. run.sh sets PORT for both sides; the backend's
// main.go reads the same variable.
const apiPort = process.env.PORT || '8080'

export default defineConfig({
  // The Vue plugin lets Vite understand .vue files (Single-File Components).
  plugins: [vue()],
  server: {
    // The proxy: when the browser asks this front-end server for a path
    // that starts with /api, Vite forwards the request to the Go API and
    // passes the answer back. To the browser everything comes from one
    // origin, so the backend needs no CORS headers.
    // `vite preview` uses the same proxy (preview.proxy defaults to it).
    proxy: {
      '/api': `http://127.0.0.1:${apiPort}`,
    },
  },
})
