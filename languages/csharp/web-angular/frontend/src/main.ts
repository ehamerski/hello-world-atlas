// main.ts - C# web-angular (frontend): the entry point. The Angular CLI
// starts the build here (angular.json -> build -> options -> browser).
//
// bootstrapApplication creates the Angular application with App as its
// root component and draws it where index.html has <app-root>.
import { bootstrapApplication } from '@angular/platform-browser';
import { App } from './app/app';

bootstrapApplication(App).catch((err) => console.error(err));
