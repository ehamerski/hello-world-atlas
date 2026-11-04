// app.ts - C# web-angular (frontend): the Angular component that asks the
// ASP.NET Core API for the greeting and shows it.
//
// This is TypeScript: JavaScript plus static types. The browser runs this
// code (compiled to JavaScript), not the server: compare ../../web, where
// C# sends the finished HTML.

import { HttpClient } from '@angular/common/http';
import { Component, inject, signal } from '@angular/core';

// The shape of the API's JSON answer. An interface only exists at compile
// time: it lets TypeScript check that data.message is a string. It plays
// the role of the Greeting record in ../backend/Program.cs.
interface Greeting {
  message: string;
}

// @Component is a decorator: it marks the class as an Angular component,
// much like a C# attribute ([STAThread] in ../../desktop) or a Java
// annotation (@RestController). "selector" is the HTML tag the component
// replaces (<app-root> in index.html); "template" is its HTML.
// {{ message() }} shows the current value of the signal below.
@Component({
  selector: 'app-root',
  template: `<p>{{ message() }}</p>`,
})
export class App {
  // A signal holds a value and tells Angular when it changes, so Angular
  // redraws the template. It starts as "Loading...".
  protected readonly message = signal('Loading...');

  // inject() asks Angular for a service. HttpClient sends HTTP requests;
  // since Angular 21 it is available without extra setup.
  private readonly http = inject(HttpClient);

  // The constructor runs once, when Angular creates the component.
  constructor() {
    // get<Greeting>() sends GET /api/hello to the server this page came
    // from (ng serve), which forwards it to the ASP.NET Core API (see
    // proxy.conf.js). The answer arrives later: subscribe() says what to do
    // with it, and the page is not frozen while waiting.
    this.http.get<Greeting>('/api/hello').subscribe({
      next: (data) => this.message.set(data.message),
      error: () => this.message.set('Could not reach the ASP.NET Core API.'),
    });
  }
}
