// HelloApplication.java - Java web: a Spring Boot server that answers
// http://localhost:8080/ with the HTML <p>Hello, World!</p>.
//
// Build and run it with ./build.sh and ./run.sh, which explain each step.
// This is the shape of the official Spring Boot "first application": one
// class that is both the application and the controller.

package com.example.hello;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

// Words starting with @ are annotations: labels that Spring reads while the
// program runs. Python's Flask uses decorators (@app.route) for the same
// job; Java code itself never calls these methods by name.
//
// @SpringBootApplication: "this is the main class". Spring scans this
//   package for components and configures itself from what is on the
//   class path (here: Spring MVC and Tomcat, so it starts a web server).
// @RestController: this class handles web requests, and whatever a
//   method returns is written directly into the HTTP response body.
@RestController
@SpringBootApplication
public class HelloApplication {

    // @GetMapping("/"): call this method for "GET /" requests.
    // produces = text/html: send the header "Content-Type: text/html", so
    // the browser renders the <p> tag instead of showing it as plain text.
    // Compare Flask: @app.route("/") above a function that returns a string.
    @GetMapping(value = "/", produces = MediaType.TEXT_HTML_VALUE)
    String hello() {
        return "<p>Hello, World!</p>";
    }

    // The entry point, as in ../cli. SpringApplication.run() starts Spring,
    // which starts the embedded Tomcat server and keeps it running until
    // you press Ctrl+C. main() itself returns right away.
    public static void main(String[] args) {
        SpringApplication.run(HelloApplication.class, args);
    }
}
