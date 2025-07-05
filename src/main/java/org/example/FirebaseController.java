package org.example;

import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.UserRecord;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/firebase")
public class FirebaseController {

    @Autowired
    private FirebaseService firebaseService;

    @GetMapping("/user/{uid}")
    public ResponseEntity<?> getUserByUid(@PathVariable String uid) {
        try {
            UserRecord userRecord = firebaseService.getUserByUid(uid);
            Map<String, Object> response = new HashMap<>();
            response.put("uid", userRecord.getUid());
            response.put("email", userRecord.getEmail());
            response.put("displayName", userRecord.getDisplayName());
            response.put("emailVerified", userRecord.isEmailVerified());
            return ResponseEntity.ok(response);
        } catch (FirebaseAuthException e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "Kullanıcı bulunamadı: " + e.getMessage());
            return ResponseEntity.badRequest().body(error);
        } catch (RuntimeException e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }

    @PostMapping("/token")
    public ResponseEntity<?> createCustomToken(@RequestBody Map<String, String> request) {
        try {
            String uid = request.get("uid");
            if (uid == null || uid.isEmpty()) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "UID gerekli");
                return ResponseEntity.badRequest().body(error);
            }
            
            String customToken = firebaseService.createCustomToken(uid);
            Map<String, String> response = new HashMap<>();
            response.put("token", customToken);
            return ResponseEntity.ok(response);
        } catch (FirebaseAuthException e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "Token oluşturulamadı: " + e.getMessage());
            return ResponseEntity.badRequest().body(error);
        } catch (RuntimeException e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }

    @PostMapping("/verify")
    public ResponseEntity<?> verifyIdToken(@RequestBody Map<String, String> request) {
        String idToken = request.get("idToken");
        if (idToken == null || idToken.isEmpty()) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "ID Token gerekli");
            return ResponseEntity.badRequest().body(error);
        }
        
        boolean isValid = firebaseService.verifyIdToken(idToken);
        Map<String, Object> response = new HashMap<>();
        response.put("valid", isValid);
        return ResponseEntity.ok(response);
    }
} 