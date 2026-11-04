<!--
  App.vue - Go web-vue (frontend): the Vue component that asks the Go API
  for the greeting and shows it.

  A .vue file is a Single-File Component: the logic (<script setup>) and
  the HTML template (<template>) of one component live in one file. Vite's
  Vue plugin compiles it to plain JavaScript. The browser runs this code,
  not the server: compare ../../web, where Go fills the HTML template.
-->
<script setup>
import { onMounted, ref } from 'vue'

// ref() makes a reactive value: when message.value changes, Vue redraws
// every place in the template that uses it. It starts as "Loading...".
const message = ref('Loading...')

// onMounted runs after the component is shown on the page, once.
// Here it calls the backend.
onMounted(async () => {
  try {
    // fetch() sends GET /api/hello to the server this page came from (the
    // Vite server), which forwards it to the Go API (see vite.config.js).
    // "await" waits for the answer without freezing the page.
    const response = await fetch('/api/hello')
    const data = await response.json() // the body is {"message":"Hello, World!"}
    message.value = data.message
  } catch {
    message.value = 'Could not reach the Go API.'
  }
})
</script>

<template>
  <!-- {{ message }} shows the current value; in the template no .value is needed. -->
  <p>{{ message }}</p>
</template>
