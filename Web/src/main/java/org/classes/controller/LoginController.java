package org.classes.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.http.ResponseEntity;
import jakarta.servlet.http.HttpSession;
import java.util.Collections;
import java.util.Map;
import org.classes.FirebaseService;
import org.springframework.beans.factory.annotation.Autowired;

@Controller
public class LoginController {

    @Autowired
    private FirebaseService firebaseService;

    @GetMapping("/login")
    public String showLoginPage() {
        // src/main/resources/templates/login.html dosyasını döndürür
        return "login";
    }

    @PostMapping("/login")
    @ResponseBody
    public ResponseEntity<?> loginWithFirebase(@RequestBody Map<String, String> body, HttpSession session) {
        System.out.println("Login isteği geldi: " + body);
        String idToken = body.get("idToken");
        if (idToken == null) {
            System.out.println("Token eksik - body: " + body);
            return ResponseEntity.badRequest().body(Collections.singletonMap("message", "Token eksik"));
        }
        System.out.println("Token alındı, uzunluk: " + idToken.length());
        // FirebaseService'i kullanarak token doğrula
        boolean valid = firebaseService.verifyIdToken(idToken);
        if (valid) {
            System.out.println("Token doğrulandı, session oluşturuluyor");
            session.setAttribute("user", "firebaseUser"); // örnek kullanıcı oturumu
            return ResponseEntity.ok().build(); // Frontend başarılı olursa ana sayfaya yönlendiriyor
        } else {
            System.out.println("Token doğrulanamadı");
            return ResponseEntity.status(401).body(Collections.singletonMap("message", "Geçersiz token"));
        }
    }
}