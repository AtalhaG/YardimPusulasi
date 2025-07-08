import 'package:flutter/material.dart';
import 'yardim_ekleme_page.dart';

class KisiDetayPage extends StatelessWidget {
  final Map<String, dynamic> kisi;
  
  const KisiDetayPage({Key? key, required this.kisi}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Kişi Detayları',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kişi Profil Kartı
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
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue[100],
                          child: Icon(
                            Icons.person,
                            size: 35,
                            color: Colors.blue[700],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                kisi['isim'] ?? 'Bilinmiyor',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1976D2),
                                ),
                              ),
                              Text(
                                'TC: ${kisi['tc'] ?? 'Bilinmiyor'}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildBilgiSatiri(
                      Icons.location_on,
                      'Adres',
                      '${kisi['sehir'] ?? 'Bilinmiyor'}, ${kisi['ilce'] ?? 'Bilinmiyor'}',
                    ),
                    _buildBilgiSatiri(
                      Icons.people,
                      'Aile Büyüklüğü',
                      '${kisi['aile_buyuklugu'] ?? 'Bilinmiyor'} kişi',
                    ),
                    _buildBilgiSatiri(
                      Icons.phone,
                      'Telefon',
                      kisi['telefon'] ?? 'Bilinmiyor',
                    ),
                    _buildBilgiSatiri(
                      Icons.calendar_today,
                      'Yaş',
                      '${kisi['yas'] ?? 'Bilinmiyor'}',
                    ),
                    _buildBilgiSatiri(
                      Icons.monetization_on,
                      'Aylık Gelir',
                      '₺${kisi['miktar'] ?? 'Bilinmiyor'}',
                    ),
                    _buildBilgiSatiri(
                      Icons.access_time,
                      'Kayıt Tarihi',
                      _formatDate(kisi['tarih']),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // İhtiyaç Açıklaması Kartı
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
                          Icons.description,
                          color: Colors.orange[700],
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'İhtiyaç Açıklaması',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1976D2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      kisi['ihtiyac'] ?? 'Çocukların okul malzemeleri ve kıyafet yardımı',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Yardım Sağla Butonu
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => YardimEklemePage(kisi: kisi),
                    ),
                  );
                },
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
                    Icon(Icons.add, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Yardım Sağla',
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
    );
  }

  Widget _buildBilgiSatiri(IconData icon, String baslik, String deger) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  baslik,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  deger,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Bilinmiyor';
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
} 