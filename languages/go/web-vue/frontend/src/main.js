// main.js - Go web-vue (frontend): the entry point of the Vue code.
// It creates the Vue application from the App component and mounts it
// into <div id="app"> in index.html.

import { createApp } from 'vue'
import App from './App.vue'

// createApp() makes an application instance; mount() draws it inside the
// element that matches the CSS selector '#app'.
createApp(App).mount('#app')
