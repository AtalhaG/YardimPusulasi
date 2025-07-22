package org.classes;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.UserRecord;
import org.springframework.stereotype.Service;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.FirestoreOptions;
import com.google.cloud.firestore.QueryDocumentSnapshot;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.QuerySnapshot;
import com.google.firebase.cloud.FirestoreClient;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import java.util.Collections;
import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.DocumentSnapshot;

@Service
public class FirebaseService {

    public UserRecord getUserByUid(String uid) throws FirebaseAuthException {
        return FirebaseAuth.getInstance().getUser(uid);
    }

    public String createCustomToken(String uid) throws FirebaseAuthException {
        return FirebaseAuth.getInstance().createCustomToken(uid);
    }

    public boolean verifyIdToken(String idToken) {
        try {
            FirebaseAuth.getInstance().verifyIdToken(idToken);
            System.out.println("Token başarıyla doğrulandı");
            return true;
        } catch (FirebaseAuthException e) {
            System.out.println("Token doğrulama hatası: " + e.getMessage());
            System.out.println("Hata kodu: " + e.getAuthErrorCode());
            return false;
        } catch (Exception e) {
            System.out.println("Genel hata: " + e.getMessage());
            return false;
        }
    }

    public boolean isFirebaseInitialized() {
        try {
            return FirebaseAuth.getInstance() != null;
        } catch (Exception e) {
            return false;
        }
    }

    // Firestore'dan bir koleksiyondaki tüm dökümanları çek
    public List<Map<String, Object>> getCollectionData(String collectionName) {
        List<Map<String, Object>> dataList = new ArrayList<>();
        try {
            Firestore db = FirestoreClient.getFirestore();
            ApiFuture<QuerySnapshot> future = db.collection(collectionName).get();
            List<QueryDocumentSnapshot> documents = future.get().getDocuments();
            for (QueryDocumentSnapshot document : documents) {
                dataList.add(document.getData());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dataList;
    }

    // Firestore'dan bolgeler koleksiyonundaki bölge isimlerini çek
    public List<String> getBolgeNames() {
        List<String> bolgeler = new ArrayList<>();
        try {
            Firestore db = FirestoreClient.getFirestore();
            ApiFuture<QuerySnapshot> future = db.collection("bolgeler").get();
            List<QueryDocumentSnapshot> documents = future.get().getDocuments();
            for (QueryDocumentSnapshot document : documents) {
                bolgeler.add(document.getId()); // Döküman ismi (bölge adı)
            }
            Collections.sort(bolgeler); // Alfabetik sıralama
        } catch (Exception e) {
            e.printStackTrace();
        }
        return bolgeler;
    }

    // Seçilen bölgeye göre alt koleksiyon isimlerini (ilçeler) getir
    public List<String> getIlcelerForBolge(String bolgeAdi) {
        List<String> ilceler = new ArrayList<>();
        try {
            Firestore db = FirestoreClient.getFirestore();
            Iterable<CollectionReference> collections = db.collection("bolgeler").document(bolgeAdi).listCollections();
            for (CollectionReference colRef : collections) {
                ilceler.add(colRef.getId());
            }
            Collections.sort(ilceler);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ilceler;
    }

    public List<Kisi> getKisilerByIlIlce(String il, String ilce) {
        List<Kisi> kisiler = new ArrayList<>();
        try {
            Firestore db = FirestoreClient.getFirestore();
            // bolgeler/{il}/{ilce} koleksiyonunu al
            ApiFuture<QuerySnapshot> future = db.collection("bolgeler")
                .document(il)
                .collection(ilce)
                .get();
            List<QueryDocumentSnapshot> documents = future.get().getDocuments();
            for (QueryDocumentSnapshot document : documents) {
                Kisi kisi = document.toObject(Kisi.class);
                kisiler.add(kisi);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return kisiler;
    }

    public void addKisiToIlIlce(Kisi kisi, String il, String ilce) {
        try {
            Firestore db = FirestoreClient.getFirestore();
            db.collection("bolgeler")
              .document(il)
              .collection(ilce)
              .add(kisi);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
} 