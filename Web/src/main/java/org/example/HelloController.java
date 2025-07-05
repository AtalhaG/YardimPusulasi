package org.example;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    @Autowired
    private FirebaseService firebaseService;

    @GetMapping("/hello")
    public String hello() {
        return "Merhaba, Firebase entegreli backend server çalışıyor!";
    }

    @GetMapping("/firebase-status")
    public String firebaseStatus() {
        try {
            if (firebaseService.isFirebaseInitialized()) {
                return "Firebase bağlantısı başarılı!";
            } else {
                return "Firebase henüz initialize edilmemiş.";
            }
        } catch (Exception e) {
            return "Firebase bağlantı hatası: " + e.getMessage();
        }
    }
}
