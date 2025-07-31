import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'yardim_ekleme_page.dart';

class KisiDetayPage extends StatefulWidget {
  final Map<String, dynamic> kisi;
  
  const KisiDetayPage({Key? key, required this.kisi}) : super(key: key);

  @override
  State<KisiDetayPage> createState() => _KisiDetayPageState();
}

class _KisiDetayPageState extends State<KisiDetayPage> {
  String _siralamaTipi = 'En Yeni';
  bool _yardimlarYukleniyor = false;
  List<Map<String, dynamic>> _yardimlar = [];

  @override
  void initState() {
    super.initState();
    _yardimlariGetir();
  }

  Future<void> _yardimlariGetir() async {
    setState(() {
      _yardimlarYukleniyor = true;
    });

    try {
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

      // Kişinin doküman ID'sini bul
      final kisiQuery = await FirebaseFirestore.instance
          .collection('bolgeler')
          .doc(sehirNorm)
          .collection(ilceNorm)
          .where('isim', isEqualTo: widget.kisi['isim'])
          .where('tc', isEqualTo: widget.kisi['tc'])
          .get();

      if (kisiQuery.docs.isNotEmpty) {
        final kisiDocId = kisiQuery.docs.first.id;
        
        // Yardımları getir
        final yardimlarSnapshot = await FirebaseFirestore.instance
            .collection('bolgeler')
            .doc(sehirNorm)
            .collection(ilceNorm)
            .doc(kisiDocId)
            .collection('yardimlar')
            .orderBy('tarih', descending: _siralamaTipi == 'En Yeni')
            .get();

        final yardimlar = yardimlarSnapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();

        setState(() {
          _yardimlar = yardimlar;
          _yardimlarYukleniyor = false;
        });
      }
    } catch (e) {
      setState(() {
        _yardimlarYukleniyor = false;
      });
      print('Yardımlar getirilirken hata: $e');
    }
  }

  void _siralamaDegistir(String yeniSiralama) {
    setState(() {
      _siralamaTipi = yeniSiralama;
    });
    _yardimlariGetir();
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
          'Kişi Detayları',
          style: TextStyle(
            color: Color(0xFF1976D2),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
                                widget.kisi['isim'] ?? 'Bilinmiyor',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1976D2),
                                ),
                              ),
                              Text(
                                'TC: ${widget.kisi['tc'] ?? 'Bilinmiyor'}',
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
                      '${widget.kisi['il'] ?? 'Bilinmiyor'}, ${widget.kisi['ilce'] ?? 'Bilinmiyor'}',
                    ),
                    _buildBilgiSatiri(
                      Icons.people,
                      'Aile Büyüklüğü',
                      '${widget.kisi['aile'] ?? 'Bilinmiyor'} kişi',
                    ),
                    _buildBilgiSatiri(
                      Icons.phone,
                      'Telefon',
                      widget.kisi['telefon'] ?? 'Bilinmiyor',
                    ),
                    _buildBilgiSatiri(
                      Icons.calendar_today,
                      'Yaş',
                      '${widget.kisi['yas'] ?? 'Bilinmiyor'}',
                    ),
                    _buildBilgiSatiri(
                      Icons.monetization_on,
                      'Aylık Gelir',
                      '₺${widget.kisi['gelir'] ?? 'Bilinmiyor'}',
                    ),
                    _buildBilgiSatiri(
                      Icons.access_time,
                      'Kayıt Tarihi',
                      _formatDate(widget.kisi['sontarih']),
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
                      widget.kisi['ihtiyac'] ?? 'Çocukların okul malzemeleri ve kıyafet yardımı',
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
            
            // Yardım Geçmişi Kartı
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
                          Icons.history,
                          color: Colors.green[700],
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Yardım Geçmişi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1976D2),
                          ),
                        ),
                        const Spacer(),
                        // Sıralama Butonu
                        PopupMenuButton<String>(
                          onSelected: _siralamaDegistir,
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'En Yeni',
                              child: Text('En Yeni'),
                            ),
                            const PopupMenuItem(
                              value: 'En Eski',
                              child: Text('En Eski'),
                            ),
                          ],
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _siralamaTipi,
                                  style: TextStyle(
                                    color: Colors.blue[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(Icons.arrow_drop_down, color: Colors.blue[700]),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    if (_yardimlarYukleniyor)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (_yardimlar.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.grey,
                                size: 48,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Henüz yardım kaydı bulunmuyor',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _yardimlar.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final yardim = _yardimlar[index];
                          return _buildYardimKarti(yardim);
                        },
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
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => YardimEklemePage(kisi: widget.kisi),
                    ),
                  );
                  // Yardım eklendikten sonra listeyi yenile
                  _yardimlariGetir();
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

  Widget _buildYardimKarti(Map<String, dynamic> yardim) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  yardim['tur'] ?? 'Bilinmiyor',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ),
              const Spacer(),
              Text(
                _formatYardimTarihi(yardim['tarih']),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.monetization_on,
                size: 16,
                color: Colors.green[600],
              ),
              const SizedBox(width: 4),
              Text(
                '₺${yardim['tutar']?.toString() ?? '0'}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            yardim['aciklama'] ?? 'Açıklama yok',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.person,
                size: 14,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                yardim['yardimSaglayan'] ?? 'Bilinmiyor',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.delivery_dining,
                size: 14,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                yardim['nasilYapildi'] ?? 'Bilinmiyor',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatYardimTarihi(dynamic tarih) {
    if (tarih == null) return 'Bilinmiyor';
    
    DateTime? date;
    if (tarih is Timestamp) {
      date = tarih.toDate();
    } else if (tarih is DateTime) {
      date = tarih;
    } else if (tarih != null) {
      date = DateTime.tryParse(tarih.toString());
    }
    
    if (date == null) return 'Bilinmiyor';
    
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  String _formatDate(dynamic tarih) {
    if (tarih == null) return 'Bilinmiyor';
    
    DateTime? date;
    if (tarih is Timestamp) {
      date = tarih.toDate();
    } else if (tarih is DateTime) {
      date = tarih;
    } else if (tarih != null) {
      date = DateTime.tryParse(tarih.toString());
    }
    
    if (date == null) return 'Bilinmiyor';
    
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
} 