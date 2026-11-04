// main.jsx - Java web-react (frontend): the entry point of the React code.
// It finds <div id="root"> in index.html and tells React to draw the App
// component inside it.

import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import App from './App.jsx'

// createRoot() connects React to that DOM element; render() shows <App />.
// StrictMode adds extra checks while developing (npm run dev) only.
createRoot(document.getElementById('root')).render(
  <StrictMode>
    <App />
  </StrictMode>,
)
