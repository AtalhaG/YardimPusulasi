package org.example;

import org.springframework.boot.SpringApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class BackendserverApplication {
    public static void main(String[] args) {
        SpringApplication.run(BackendserverApplication.class, args);
    }
}
