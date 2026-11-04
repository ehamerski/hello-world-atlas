// App.jsx - Java web-react (frontend): the React component that asks the
// Spring Boot API for the greeting and shows it.
//
// This file is JavaScript with JSX: the <p>...</p> below is not a string
// but a description of the HTML React should draw. The browser runs this
// code, not the server: compare ../../web, where Java builds the HTML.

import { useEffect, useState } from 'react'

// A component is a function that returns what to show.
export default function App() {
  // useState keeps a value between redraws. "message" starts as
  // "Loading..."; calling setMessage() changes it and React redraws.
  const [message, setMessage] = useState('Loading...')

  // useEffect runs code after the component is shown. The empty list []
  // means: only once, not after every redraw. Here it calls the backend.
  useEffect(() => {
    // fetch() sends GET /api/hello to the server this page came from (the
    // Vite server), which forwards it to Spring Boot (see vite.config.js).
    fetch('/api/hello')
      .then((response) => response.json()) // the body is {"message":"Hello, World!"}
      .then((data) => setMessage(data.message))
      .catch(() => setMessage('Could not reach the Spring Boot API.'))
  }, [])

  return <p>{message}</p>
}
