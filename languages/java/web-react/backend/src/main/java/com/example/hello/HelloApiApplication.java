// HelloApiApplication.java - Java web-react (backend): a Spring Boot API
// that answers GET /api/hello with the JSON {"message":"Hello, World!"}.
//
// Unlike ../../web, this server sends no HTML at all. The page is built in
// the browser by the separate React front end (../frontend), which calls
// this API and shows the message. Build and run both with ../build.sh and
// ../run.sh.

package com.example.hello;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

// @SpringBootApplication and @RestController work as in ../../web: this
// class starts Spring and also handles the web requests.
@RestController
@SpringBootApplication
public class HelloApiApplication {

    // A record (Java 16+) is a class that only carries data. This one line
    // gives Greeting a constructor, a message() accessor, equals(),
    // hashCode() and toString(). Spring's JSON library (Jackson) turns a
    // Greeting into {"message":"..."}.
    record Greeting(String message) {}

    // GET /api/hello returns a Greeting object, not a String. Because the
    // class is a @RestController, Spring writes it to the response as JSON
    // ("Content-Type: application/json"). The /api prefix keeps the API's
    // paths apart from the front end's pages.
    @GetMapping("/api/hello")
    Greeting hello() {
        return new Greeting("Hello, World!");
    }

    // The entry point: start Spring and its embedded Tomcat server.
    public static void main(String[] args) {
        SpringApplication.run(HelloApiApplication.class, args);
    }
}
