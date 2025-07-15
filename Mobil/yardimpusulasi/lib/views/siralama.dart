import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'yenikisieklepage.dart';
import 'kisi_detay_page.dart';

class SiralamaPage extends StatefulWidget {
  const SiralamaPage({Key? key}) : super(key: key);

  @override
  State<SiralamaPage> createState() => _SiralamaPageState();
}

class _SiralamaPageState extends State<SiralamaPage> {
  final Map<String, List<String>> _ilceler = {
    'İstanbul': ['beylikduzu', 'Beşiktaş', 'Üsküdar'],
    'Ankara': ['sincan', 'Keçiören', 'Yenimahalle'],
    'İzmir': ['Konak', 'Bornova', 'Karşıyaka'],
  };

  String? _selectedSehir;
  String? _selectedIlce;

  String _search = '';
  String _sort = 'Gelir/Kişi';
  String _sortDirection = 'desc'; // 'asc' veya 'desc'

  bool _showList = false;
  bool _searchStarted = false;

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

  Future<List<Map<String, dynamic>>> getVatandaslar(
    String sehir,
    String ilce,
  ) async {
    final sehirLower = normalize(sehir);
    final ilceLower = normalize(ilce);
    debugPrint('Firestore sorgusu: bolgeler/$sehirLower/$ilceLower');
    final snapshot = await FirebaseFirestore.instance
        .collection('bolgeler')
        .doc(sehirLower)
        .collection(ilceLower)
        .get();
    debugPrint('Firestore dönen kişi sayısı: ${snapshot.docs.length}');
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // Sıralama tipi
  String _sortType = 'Alfabetik'; // veya 'Son Yardım Tarihi'

  void _showSortOptions() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.sort_by_alpha),
                title: const Text('Alfabetik'),
                onTap: () => Navigator.pop(context, 'Alfabetik'),
                selected: _sortType == 'Alfabetik',
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Son Yardım Tarihi'),
                onTap: () => Navigator.pop(context, 'Son Yardım Tarihi'),
                selected: _sortType == 'Son Yardım Tarihi',
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
    if (selected != null && selected != _sortType) {
      setState(() {
        _sortType = selected;
      });
    }
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
          ? SafeArea(
              child: SingleChildScrollView(
                child: Center(
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
                                  color: Color(0xFF1976D2), // Mavi başlık
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
                                      DropdownButtonFormField<String>(
                                        value: _selectedSehir,
                                        decoration: InputDecoration(
                                          labelText: 'İl',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
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
                                      const SizedBox(height: 12),
                                      DropdownButtonFormField<String>(
                                        value: _selectedIlce,
                                        decoration: InputDecoration(
                                          labelText: 'İlçe',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
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
                                                  (ilce) =>
                                                      DropdownMenuItem(
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
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Card(
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DropdownButtonFormField<String>(
                              value: _selectedSehir,
                              decoration: InputDecoration(
                                labelText: 'İl',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              items: _ilceler.keys
                                  .map((sehir) => DropdownMenuItem(
                                        value: sehir,
                                        child: Text(sehir),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  _selectedSehir = val;
                                  _selectedIlce = null;
                                });
                              },
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: _selectedIlce,
                                    decoration: InputDecoration(
                                      labelText: 'İlçe',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                    ),
                                    items: (_selectedSehir != null
                                            ? _ilceler[_selectedSehir] ?? []
                                            : <String>[])
                                        .map((ilce) => DropdownMenuItem(
                                              value: ilce,
                                              child: Text(ilce),
                                            ))
                                        .toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        _selectedIlce = val;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                SizedBox(
                                  height: 56,
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.search),
                                    label: const Text('Ara'),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                      ),
                                      textStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: (_selectedSehir != null && _selectedIlce != null)
                                        ? () => setState(() {
                                              _searchStarted = true;
                                              _showList = true;
                                            })
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (!_showList)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue[200],
                              size: 48,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'İl ve ilçe seçin',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Tabloyu görmek için il ve ilçe seçimi yapın ve Ara butonuna basın',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (_showList &&
                      _selectedSehir != null &&
                      _selectedIlce != null)
                    Expanded(
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: getVatandaslar(_selectedSehir!, _selectedIlce!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Hata:  ${snapshot.error}'),
                            );
                          }
                          final vatandaslar = snapshot.data ?? [];
                          // Search bar filtresi uygula
                          final filteredVatandaslar = _search.isEmpty
                              ? vatandaslar
                              : vatandaslar.where((v) {
                                  final isim = (v['isim'] ?? '').toString();
                                  final aciklama = (v['sonaciklama'] ?? '')
                                      .toString();
                                  final searchLower = normalize(_search);
                                  return normalize(
                                        isim,
                                      ).contains(searchLower) ||
                                      normalize(aciklama).contains(searchLower);
                                }).toList();
                          if (filteredVatandaslar.isEmpty) {
                            return const Center(
                              child: Text('Kayıt bulunamadı.'),
                            );
                          }
                          // Sıralama uygula
                          List<Map<String, dynamic>> sortedList = List.from(
                            filteredVatandaslar,
                          );
                          if (_sortType == 'Alfabetik') {
                            sortedList.sort(
                              (a, b) => (a['isim'] ?? '')
                                  .toString()
                                  .toLowerCase()
                                  .compareTo(
                                    (b['isim'] ?? '').toString().toLowerCase(),
                                  ),
                            );
                          } else if (_sortType == 'Son Yardım Tarihi') {
                            sortedList.sort((a, b) {
                              final tA = a['sontarih'];
                              final tB = b['sontarih'];
                              DateTime? dA, dB;
                              if (tA is Timestamp)
                                dA = tA.toDate();
                              else if (tA is DateTime)
                                dA = tA;
                              else if (tA != null)
                                dA = DateTime.tryParse(tA.toString());
                              if (tB is Timestamp)
                                dB = tB.toDate();
                              else if (tB is DateTime)
                                dB = tB;
                              else if (tB != null)
                                dB = DateTime.tryParse(tB.toString());
                              if (dA == null && dB == null) return 0;
                              if (dA == null) return 1;
                              if (dB == null) return -1;
                              return dB.compareTo(dA); // Yeni tarih önce gelsin
                            });
                          }
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 20,
                                ),
                                child: Card(
                                  color: Colors.white,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.group,
                                          color: Color(0xFFFF2D55),
                                          size: 36,
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${sortedList.length}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 32,
                                                color: Color(0xFF111827),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            const Text(
                                              'İhtiyaç sahibi vatandaş sayısı',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF374151),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  bottom: 8,
                                ),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton.icon(
                                    onPressed: _showSortOptions,
                                    icon: const Icon(Icons.sort, size: 20),
                                    label: Text(_sortType),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue[50],
                                      foregroundColor: Colors.blue[900],
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.separated(
                                  itemCount: sortedList.length,
                                  separatorBuilder: (context, i) =>
                                      const SizedBox(height: 16),
                                  itemBuilder: (context, i) {
                                    final v = sortedList[i];
                                    return InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                KisiDetayPage(kisi: v),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        elevation: 4,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 18,
                                            horizontal: 18,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CircleAvatar(
                                                backgroundColor:
                                                    Colors.blue[100],
                                                child: const Icon(
                                                  Icons.person,
                                                  color: Colors.blue,
                                                  size: 28,
                                                ),
                                                radius: 28,
                                              ),
                                              const SizedBox(width: 18),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      v['isim'] ?? '',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Color(
                                                          0xFF111827,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Text(
                                                      v['sonaciklama'] ?? '',
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Color(
                                                          0xFF374151,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    v['sontarih'] != null
                                                        ? (v['sontarih']
                                                                  is Timestamp
                                                              ? (v['sontarih']
                                                                        as Timestamp)
                                                                    .toDate()
                                                                    .toString()
                                                                    .split(
                                                                      ' ',
                                                                    )[0]
                                                              : v['sontarih']
                                                                    .toString())
                                                        : '',
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      color: Color(0xFF6B7280),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                ],
              ),
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
              const SizedBox(width: 32),
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
