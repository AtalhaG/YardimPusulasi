# Firebase Backend Projesi

Bu proje, Spring Boot ve Firebase Admin SDK kullanarak oluşturulmuş bir backend uygulamasıdır.

## Özellikler

- ✅ Firebase Authentication entegrasyonu
- ✅ Firebase Admin SDK ile kullanıcı yönetimi
- ✅ RESTful API endpoints
- ✅ Spring Boot 3.x desteği

## Kurulum

### Gereksinimler

- Java 21
- Maven 3.6+
- Firebase projesi ve service account dosyası

### Çalıştırma

1. Projeyi klonlayın:
```bash
git clone <repository-url>
cd firebaseproject
```

2. Firebase service account dosyasını `src/main/resources/` klasörüne yerleştirin:
   - `yardimpusulasi-7f78f-firebase-adminsdk-fbsvc-fa45bfdbd9.json`

3. Uygulamayı çalıştırın:
```bash
mvn spring-boot:run
```

4. Uygulama http://localhost:8080 adresinde çalışacaktır.

## API Endpoints

### Temel Endpoints

- `GET /hello` - Basit selamlama mesajı
- `GET /firebase-status` - Firebase bağlantı durumu

### Firebase API Endpoints

- `GET /api/firebase/user/{uid}` - Kullanıcı bilgilerini getir
- `POST /api/firebase/token` - Custom token oluştur
- `POST /api/firebase/verify` - ID token doğrula

### Örnek Kullanım

#### Custom Token Oluşturma
```bash
curl -X POST http://localhost:8080/api/firebase/token \
  -H "Content-Type: application/json" \
  -d '{"uid": "user123"}'
```

#### Token Doğrulama
```bash
curl -X POST http://localhost:8080/api/firebase/verify \
  -H "Content-Type: application/json" \
  -d '{"idToken": "your-id-token"}'
```

## Proje Yapısı

```
src/main/java/org/example/
├── BackendserverApplication.java    # Ana uygulama sınıfı
├── FirebaseConfig.java             # Firebase konfigürasyonu
├── FirebaseService.java            # Firebase servis sınıfı
├── FirebaseController.java         # Firebase API controller
└── HelloController.java            # Temel controller

src/main/resources/
├── application.properties          # Uygulama konfigürasyonu
└── yardimpusulasi-7f78f-firebase-adminsdk-fbsvc-fa45bfdbd9.json  # Firebase service account
```

## Firebase Konfigürasyonu

Proje, Firebase Admin SDK kullanarak Firebase Authentication ile entegre edilmiştir. Firebase service account dosyası `src/main/resources/` klasöründe bulunmalıdır.

## Güvenlik

- Firebase Authentication kullanılarak güvenli kimlik doğrulama
- Service account dosyası güvenli şekilde yönetilmeli
- Production ortamında environment variables kullanılmalı

## Geliştirme

### Yeni Endpoint Ekleme

1. `FirebaseController.java` dosyasına yeni endpoint ekleyin
2. Gerekirse `FirebaseService.java` dosyasına yeni metod ekleyin
3. Test edin

### Firebase Özellikleri Ekleme

Firebase Admin SDK'nın diğer özelliklerini (Firestore, Realtime Database, Storage) eklemek için:

1. `pom.xml` dosyasına gerekli bağımlılıkları ekleyin
2. Yeni servis sınıfları oluşturun
3. Controller'lara yeni endpoint'ler ekleyin

## Lisans

Bu proje MIT lisansı altında lisanslanmıştır. 