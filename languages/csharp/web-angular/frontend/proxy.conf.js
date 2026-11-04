// proxy.conf.js - C# web-angular (frontend): proxy rules for "ng serve",
// the Angular CLI's development server (angular.json -> serve ->
// proxyConfig points here).
// Reference: https://angular.dev/tools/cli/serve#proxying-to-a-backend-server
//
// When the browser asks the front-end server for a path under /api, the
// server forwards the request to the ASP.NET Core API and passes the answer
// back. To the browser everything comes from one origin, so the backend
// needs no CORS headers. A .js file (instead of the proxy.conf.json shown in
// the Angular docs) is used so the API's port can come from an environment
// variable. It is API_PORT, not PORT: ng serve reads PORT as its OWN port,
// so ../run.sh removes PORT for ng serve and passes the API's port here.

const apiPort = process.env.API_PORT || '8080';

module.exports = {
  '/api/**': {
    target: `http://127.0.0.1:${apiPort}`,
    secure: false,
  },
};
