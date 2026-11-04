// vite.config.js - Java web-react (frontend): settings for Vite, the tool
// that serves the React front end in development (npm run dev), builds it
// into plain HTML/JS files (npm run build -> dist/) and serves that build
// (npm run preview).
// Reference: https://vite.dev/config/

import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'

// Where the Spring Boot API listens. run.sh sets PORT for both sides; the
// backend's application.properties reads the same variable.
const apiPort = process.env.PORT || '8080'

export default defineConfig({
  // The React plugin lets Vite understand JSX (the <p>...</p> inside .jsx).
  plugins: [react()],
  server: {
    // The proxy: when the browser asks this front-end server for a path
    // that starts with /api, Vite forwards the request to Spring Boot and
    // passes the answer back. To the browser everything comes from one
    // origin, so no CORS settings are needed in the backend.
    // `vite preview` uses the same proxy (preview.proxy defaults to it).
    proxy: {
      '/api': `http://127.0.0.1:${apiPort}`,
    },
  },
})
