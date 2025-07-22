package org.classes;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import jakarta.annotation.PostConstruct;
import java.io.IOException;
import java.io.InputStream;

@Configuration
public class FirebaseConfig implements WebMvcConfigurer {

    @PostConstruct
    public void initializeFirebase() {
        try {
            if (FirebaseApp.getApps().isEmpty()) {
                InputStream serviceAccount = new ClassPathResource("yardimpusulasi-7f78f-firebase-adminsdk-fbsvc-d67d4b468a.json").getInputStream();
                
                FirebaseOptions options = FirebaseOptions.builder()
                        .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                        .build();

                FirebaseApp.initializeApp(options);
                System.out.println("Firebase başarıyla initialize edildi!");
            }
        } catch (IOException e) {
            System.err.println("Firebase initialize hatası: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Bean
    public FirebaseApp firebaseApp() {
        if (FirebaseApp.getApps().isEmpty()) {
            return null;
        }
        return FirebaseApp.getInstance();
    }

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
            .allowedOrigins("*")
            .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
            .allowedHeaders("*");
    }
} 