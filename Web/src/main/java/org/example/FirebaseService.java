package org.example;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.UserRecord;
import org.springframework.stereotype.Service;

@Service
public class FirebaseService {

    private FirebaseAuth firebaseAuth;

    public FirebaseService() {
        // FirebaseApp'in initialize edilmesini bekle
        try {
            this.firebaseAuth = FirebaseAuth.getInstance();
        } catch (Exception e) {
            // Firebase henüz initialize edilmemiş, null olarak bırak
            this.firebaseAuth = null;
        }
    }

    public UserRecord getUserByUid(String uid) throws FirebaseAuthException {
        if (firebaseAuth == null) {
            throw new RuntimeException("Firebase henüz initialize edilmemiş");
        }
        return firebaseAuth.getUser(uid);
    }

    public String createCustomToken(String uid) throws FirebaseAuthException {
        if (firebaseAuth == null) {
            throw new RuntimeException("Firebase henüz initialize edilmemiş");
        }
        return firebaseAuth.createCustomToken(uid);
    }

    public boolean verifyIdToken(String idToken) {
        if (firebaseAuth == null) {
            return false;
        }
        try {
            firebaseAuth.verifyIdToken(idToken);
            return true;
        } catch (FirebaseAuthException e) {
            return false;
        }
    }

    public boolean isFirebaseInitialized() {
        return firebaseAuth != null;
    }
} 