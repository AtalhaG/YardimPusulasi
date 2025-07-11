import 'package:flutter/material.dart';
import 'yeni_kisi_ekle.dart';
import '../kisisel_data.dart';

class SiralamaPage extends StatefulWidget {
  const SiralamaPage({Key? key}) : super(key: key);

  @override
  State<SiralamaPage> createState() => _SiralamaPageState();
}

class _SiralamaPageState extends State<SiralamaPage> {
  final List<Map<String, dynamic>> _data = [
    {
      'isim': 'Ahmet Yılmaz',
      'tarih': DateTime(2024, 6, 1),
      'miktar': 1200,
      'sehir': 'İstanbul',
      'ilce': 'Kadıköy',
    },
    {
      'isim': 'Zeynep Kaya',
      'tarih': DateTime(2024, 5, 20),
      'miktar': 800,
      'sehir': 'İstanbul',
      'ilce': 'Kadıköy',
    },
    {
      'isim': 'Mehmet Demir',
      'tarih': DateTime(2024, 6, 3),
      'miktar': 500,
      'sehir': 'Ankara',
      'ilce': 'Çankaya',
    },
    {
      'isim': 'Elif Çelik',
      'tarih': DateTime(2024, 4, 15),
      'miktar': 2000,
      'sehir': 'Ankara',
      'ilce': 'Keçiören',
    },
    {
      'isim': 'Burak Aksoy',
      'tarih': DateTime(2024, 6, 2),
      'miktar': 1500,
      'sehir': 'İzmir',
      'ilce': 'Konak',
    },
  ];

  final Map<String, List<String>> _ilceler = {
    'İstanbul': ['Kadıköy', 'Beşiktaş', 'Üsküdar'],
    'Ankara': ['Çankaya', 'Keçiören', 'Yenimahalle'],
    'İzmir': ['Konak', 'Bornova', 'Karşıyaka'],
  };

  String? _selectedSehir;
  String? _selectedIlce;

  String _search = '';
  String _sort = 'Gelir/Kişi';
  String _sortDirection = 'desc'; // 'asc' veya 'desc'

  bool _showList = false;
  bool _searchStarted = false;

  // KisiselData'daki kişileri düz bir listeye çevirip _data ile birleştir
  List<Map<String, dynamic>> get _allKisiler {
    final List<Map<String, dynamic>> yeniKisiler = [];
    KisiselData.ilceyeGoreKisiler.forEach((ilce, kisiler) {
      for (var kisi in kisiler) {
        yeniKisiler.add({
          ...kisi,
          'ilce': ilce,
          'sehir': kisi['il'] ?? '',
        });
      }
    });
    return [..._data, ...yeniKisiler];
  }

  List<Map<String, dynamic>> get _filteredData {
    List<Map<String, dynamic>> filtered = _allKisiler
        .where(
          (item) => (item['isim'] ?? '').toLowerCase().contains(_search.toLowerCase()),
        )
        .toList();
    if (_selectedSehir != null) {
      filtered = filtered
          .where((item) => item['sehir'] == _selectedSehir)
          .toList();
    }
    if (_selectedIlce != null) {
      filtered = filtered
          .where((item) => item['ilce'] == _selectedIlce)
          .toList();
    }
    if (_sort == 'Gelir/Kişi') {
      filtered.sort(
        (a, b) => _sortDirection == 'asc'
            ? (a['miktar'] ?? 0).compareTo(b['miktar'] ?? 0)
            : (b['miktar'] ?? 0).compareTo(a['miktar'] ?? 0),
      );
    } else if (_sort == 'Tarih') {
      filtered.sort(
        (a, b) => _sortDirection == 'asc'
            ? (a['tarih'] ?? DateTime(2000)).compareTo(b['tarih'] ?? DateTime(2000))
            : (b['tarih'] ?? DateTime(2000)).compareTo(a['tarih'] ?? DateTime(2000)),
      );
    } else if (_sort == 'Alfabe') {
      filtered.sort(
        (a, b) => _sortDirection == 'asc'
            ? (a['isim'] ?? '').compareTo(b['isim'] ?? '')
            : (b['isim'] ?? '').compareTo(a['isim'] ?? ''),
      );
    }
    return filtered;
  }

  // Seçili ilçedeki eklenen kişileri getir
  List<Map<String, dynamic>> get _filteredIlceKisileri {
    final String? ilce = _selectedIlce;
    if (ilce == null) return [];
    return KisiselData.ilceyeGoreKisiler[ilce]?.map((kisi) => {
      ...kisi,
      'ilce': ilce,
      'sehir': kisi['il'] ?? '',
    }).toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 2,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12, right: 8),
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.favorite, color: Colors.white, size: 24),
            ),
          ),
        ),
        title: _searchStarted
            ? SizedBox(
                height: 40,
                child: TextField(
                  readOnly: false,
                  decoration: InputDecoration(
                    hintText: 'Ara',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 12,
                    ),
                  ),
                  onChanged: (val) => setState(() {
                    _search = val;
                  }),
                ),
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            tooltip: 'Çıkış',
            onPressed: () {
              // Çıkış işlemi burada yapılabilir
            },
          ),
        ],
      ),
      body: !_searchStarted
          ? Center(
              child: Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 32,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            'Konum Filtresi',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.blue[900],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Card(
                        color: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 20,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // İl/ilçe seçim kartında seçimler ve buton
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 140,
                                        child: DropdownButtonFormField<String>(
                                          value: _selectedSehir,
                                          decoration: InputDecoration(
                                            labelText: 'İl',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(
                                                12,
                                              ),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 8,
                                                ),
                                          ),
                                          items: _ilceler.keys
                                              .map(
                                                (sehir) => DropdownMenuItem(
                                                  value: sehir,
                                                  child: Text(sehir),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (val) {
                                            setState(() {
                                              _selectedSehir = val;
                                              _selectedIlce = null;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      SizedBox(
                                        width: 140,
                                        child: DropdownButtonFormField<String>(
                                          value: _selectedIlce,
                                          decoration: InputDecoration(
                                            labelText: 'İlçe',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(
                                                12,
                                              ),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 8,
                                                ),
                                          ),
                                          items:
                                              (_selectedSehir != null
                                                      ? _ilceler[_selectedSehir] ??
                                                            []
                                                      : <String>[])
                                                  .map(
                                                    (ilce) => DropdownMenuItem(
                                                      value: ilce,
                                                      child: Text(ilce),
                                                    ),
                                                  )
                                                  .toList(),
                                          onChanged: (val) {
                                            setState(() {
                                              _selectedIlce = val;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      width: 180,
                                      child: ElevatedButton.icon(
                                        icon: const Icon(Icons.search),
                                        label: const Text('Ara'),
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                          textStyle: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onPressed:
                                            (_selectedSehir != null &&
                                                _selectedIlce != null)
                                                ? () => setState(() {
                                                    _searchStarted = true;
                                                    _showList = true;
                                                  })
                                                : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Column(
                        children: [
                          Icon(
                            Icons.add_circle_outline,
                            color: Colors.blue[200],
                            size: 48,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Başlamak için konum seçin',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Önce il ve ilçe seçimi yaparak yardım almış kişileri görüntüleyin',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_selectedIlce != null && _filteredIlceKisileri.isNotEmpty)
                  ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        "Seçili İlçedeki Eklenen Kişiler",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1976D2)),
                      ),
                    ),
                    ..._filteredIlceKisileri.map((kisi) => ListTile(
                          title: Text('${kisi['isim']} ${kisi['soyad']}'),
                          subtitle: Text('${kisi['il']} / ${kisi['ilce']}'),
                        )),
                  ],
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Card(
                      color: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            // Modern başlık satırı
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFE3F2FD),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 12,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'İsim',
                                      style: TextStyle(
                                        color: _sort == 'Alfabe'
                                            ? Colors.blue
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'En Son Yardım Tarihi',
                                      style: TextStyle(
                                        color: _sort == 'Tarih'
                                            ? Colors.blue
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Son Yardım Miktarı',
                                      style: TextStyle(
                                        color: _sort == 'Gelir/Kişi'
                                            ? Colors.blue
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Satırlar
                            Expanded(
                              child: ListView.separated(
                                itemCount: _filteredData.length,
                                separatorBuilder: (context, i) =>
                                    const Divider(
                                      height: 1,
                                      color: Color(0xFFF0F0F0),
                                    ),
                                itemBuilder: (context, i) {
                                  final item = _filteredData[i];
                                  return Container(
                                    color: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 8,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            item['isim'],
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            item['tarih'] != null
                                                ? '${item['tarih'].day.toString().padLeft(2, '0')}.${item['tarih'].month.toString().padLeft(2, '0')}.${item['tarih'].year}'
                                                : '-',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            item['miktar'] != null
                                                ? '${item['miktar']} ₺'
                                                : '-',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.list, size: 32),
                color: Colors.blue,
                onPressed: () {
                  // Liste görünümü aksiyonu
                },
              ),
              SizedBox(
                width: 32,
              ), // Ortadaki butonun alanı için boşluk bırakıyoruz
              IconButton(
                icon: const Icon(Icons.history, size: 32),
                color: Colors.blue,
                onPressed: () {
                  // Geçmiş aksiyonu
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const YeniKisiEklePage()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white, size: 32),
        elevation: 4,
      ),
    );
  }
}
