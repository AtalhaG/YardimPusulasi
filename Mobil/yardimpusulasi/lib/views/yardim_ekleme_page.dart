import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class YardimEklemePage extends StatefulWidget {
  final Map<String, dynamic> kisi;
  
  const YardimEklemePage({Key? key, required this.kisi}) : super(key: key);

  @override
  State<YardimEklemePage> createState() => _YardimEklemePageState();
}

class _YardimEklemePageState extends State<YardimEklemePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tutarController = TextEditingController();
  final TextEditingController _aciklamaController = TextEditingController();
  
  String? _selectedYardimTuru;
  String? _selectedNasilYapildi;
  
  final List<String> _yardimTurleri = [
    'Yardım türü seçin',
    'Nakit Yardım',
    'Gıda Yardımı',
    'Giyim Yardımı',
    'Eğitim Yardımı',
    'Sağlık Yardımı',
    'Barınma Yardımı',
    'Isıtma Yardımı',
    'Ulaşım Yardımı',
    'İş Yardımı',
    'Ev Eşyası Yardımı',
    'Teknoloji Yardımı',
    'Spor Malzemesi Yardımı',
    'Kitap Yardımı',
    'Oyuncak Yardımı',
    'Diğer'
  ];

  final List<String> _nasilYapildiSecenekleri = [
    'Nasıl yapıldığını seçin',
    'Nakit olarak teslim edildi',
    'Banka transferi yapıldı',
    'Eşya olarak teslim edildi',
    'Kupon/kart verildi',
    'Havale/EFT yapıldı',
    'Kargo ile gönderildi',
    'Yerinde teslim edildi',
    'Diğer'
  ];

  @override
  void dispose() {
    _tutarController.dispose();
    _aciklamaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1976D2)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Yardım Sağla',
          style: TextStyle(
            color: Color(0xFF1976D2),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kişi Bilgileri Kartı
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.blue[700],
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Kişi Bilgileri',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1976D2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildKisiBilgi('Adres:', '${widget.kisi['il'] ?? 'Bilinmiyor'}, ${widget.kisi['ilce'] ?? 'Bilinmiyor'}'),
                      _buildKisiBilgi('Telefon:', widget.kisi['telefon'] ?? 'Bilinmiyor'),
                      _buildKisiBilgi('Aile Büyüklüğü:', '${widget.kisi['aile'] ?? 'Bilinmiyor'} kişi'),
                      _buildKisiBilgi('Aylık Gelir:', '₺${widget.kisi['gelir'] ?? 'Bilinmiyor'}'),
                      _buildKisiBilgi('İhtiyaç:', widget.kisi['ihtiyac'] ?? 'Bilinmiyor'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Yardım Formu Kartı
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Yardım Türü
                      const Text(
                        'Yardım Türü *',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedYardimTuru,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF1976D2)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF1976D2)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        ),
                        items: _yardimTurleri.map((tur) => DropdownMenuItem(
                          value: tur,
                          child: Text(tur),
                        )).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedYardimTuru = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value == 'Yardım türü seçin') {
                            return 'Yardım türü seçilmelidir';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Nasıl Yapıldı
                      const Text(
                        'Nasıl Yapıldı *',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedNasilYapildi,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF1976D2)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF1976D2)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        ),
                        items: _nasilYapildiSecenekleri.map((secenek) => DropdownMenuItem(
                          value: secenek,
                          child: Text(secenek),
                        )).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedNasilYapildi = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value == 'Nasıl yapıldığını seçin') {
                            return 'Nasıl yapıldığı seçilmelidir';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Tutar
                      const Text(
                        'Tutar (TL) *',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _tutarController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF1976D2)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF1976D2)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Tutar girilmelidir';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Açıklama
                      const Text(
                        'Açıklama *',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _aciklamaController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Yardımın detaylarını açıklayın...',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF1976D2)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF1976D2)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Açıklama girilmelidir';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Yardım Sağlayan Bilgileri Kartı
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Yardım Sağlayan Bilgileri',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            _buildYardimSaglayan('Vakıf:', 'Yardım Vakfı'),
                            _buildYardimSaglayan('Personel:', 'admin'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Kaydet Butonu
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () => _yardimKaydet(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Yardım Kaydet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKisiBilgi(String baslik, String deger) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              baslik,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              deger,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYardimSaglayan(String baslik, String deger) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              baslik,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              deger,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _yardimKaydet() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Firebase'e yardım kaydetme
        final yardimData = {
          'tur': _selectedYardimTuru,
          'tutar': double.tryParse(_tutarController.text) ?? 0.0,
          'aciklama': _aciklamaController.text,
          'tarih': FieldValue.serverTimestamp(),
          'yardimSaglayan': 'Yardım Vakfı',
          'nasilYapildi': _selectedNasilYapildi,
        };

        // Kişinin bulunduğu il ve ilçe bilgilerini al
        final sehir = widget.kisi['il'] ?? 'İzmir';
        final ilce = widget.kisi['ilce'] ?? 'Konak';
        
        // Normalize et
        String normalize(String input) {
          return input
              .toLowerCase()
              .replaceAll('ı', 'i')
              .replaceAll('ğ', 'g')
              .replaceAll('ü', 'u')
              .replaceAll('ş', 's')
              .replaceAll('ö', 'o')
              .replaceAll('ç', 'c')
              .replaceAll('İ', 'i');
        }

        final sehirNorm = normalize(sehir);
        final ilceNorm = normalize(ilce);

        // Kişinin doküman ID'sini bul (isim ve TC ile)
        final kisiQuery = await FirebaseFirestore.instance
            .collection('bolgeler')
            .doc(sehirNorm)
            .collection(ilceNorm)
            .where('isim', isEqualTo: widget.kisi['isim'])
            .where('tc', isEqualTo: widget.kisi['tc'])
            .get();

        if (kisiQuery.docs.isNotEmpty) {
          final kisiDocId = kisiQuery.docs.first.id;
          
          // Yardımı subcollection'a ekle
          await FirebaseFirestore.instance
              .collection('bolgeler')
              .doc(sehirNorm)
              .collection(ilceNorm)
              .doc(kisiDocId)
              .collection('yardimlar')
              .add(yardimData);

          // Kişinin son yardım bilgilerini güncelle
          await FirebaseFirestore.instance
              .collection('bolgeler')
              .doc(sehirNorm)
              .collection(ilceNorm)
              .doc(kisiDocId)
              .update({
                'sontarih': FieldValue.serverTimestamp(),
                'sonaciklama': _aciklamaController.text,
              });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Yardım başarıyla kaydedildi!'),
              backgroundColor: Color(0xFF1976D2),
            ),
          );
          
          // Kişi detay sayfasına geri dön
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kişi bulunamadı!'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
} 