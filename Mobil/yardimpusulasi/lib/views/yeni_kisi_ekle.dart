import 'package:flutter/material.dart';

class YeniKisiEklePage extends StatefulWidget {
  const YeniKisiEklePage({Key? key}) : super(key: key);

  @override
  State<YeniKisiEklePage> createState() => _YeniKisiEklePageState();
}

class _YeniKisiEklePageState extends State<YeniKisiEklePage> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  final TextEditingController _adController = TextEditingController();
  final TextEditingController _soyadController = TextEditingController();
  final TextEditingController _yasController = TextEditingController();
  final TextEditingController _tcController = TextEditingController();
  final TextEditingController _telefonController = TextEditingController();
  final TextEditingController _aileController = TextEditingController();
  final TextEditingController _gelirController = TextEditingController();
  final TextEditingController _adresController = TextEditingController();
  final TextEditingController _ihtiyacController = TextEditingController();

  // İl ve ilçe için örnek veri
  final List<String> _iller = [
    'İstanbul', 'Ankara', 'İzmir', 'Bursa', 'Antalya'
  ];
  final Map<String, List<String>> _ilceler = {
    'İstanbul': ['Kadıköy', 'Beşiktaş', 'Üsküdar', 'Bakırköy'],
    'Ankara': ['Çankaya', 'Keçiören', 'Yenimahalle'],
    'İzmir': ['Konak', 'Bornova', 'Karşıyaka'],
    'Bursa': ['Osmangazi', 'Nilüfer', 'Yıldırım'],
    'Antalya': ['Muratpaşa', 'Kepez', 'Konyaaltı'],
  };
  String? _selectedIl;
  String? _selectedIlce;

  @override
  void dispose() {
    _adController.dispose();
    _soyadController.dispose();
    _yasController.dispose();
    _tcController.dispose();
    _telefonController.dispose();
    _aileController.dispose();
    _gelirController.dispose();
    _adresController.dispose();
    _ihtiyacController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FA),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black54, size: 20),
              onPressed: () => Navigator.of(context).maybePop(),
              tooltip: 'Geri Dön',
            ),
            const SizedBox(width: 4),
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.blue[50],
              child: Icon(Icons.person, size: 28, color: Colors.blue[700]),
            ),
            const SizedBox(width: 12),
            const Text(
              "Yeni Kişi Ekle",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 700),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
              child: Form(
                key: _formKey,
                child: isWide
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(child: _buildTextField(_adController, "Ad")),
                              const SizedBox(width: 18),
                              Expanded(child: _buildTextField(_soyadController, "Soyad")),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: _buildTextField(_yasController, "Yaş", keyboardType: TextInputType.number)),
                              const SizedBox(width: 18),
                              Expanded(child: _buildTextField(_tcController, "TC Kimlik No", keyboardType: TextInputType.number)),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: _buildTextField(_telefonController, "Telefon", keyboardType: TextInputType.phone)),
                              const SizedBox(width: 18),
                              Expanded(child: _buildTextField(_aileController, "Aile Büyüklüğü", keyboardType: TextInputType.number)),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: _buildTextField(_gelirController, "Aylık Gelir (TL)", keyboardType: TextInputType.number)),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: DropdownButtonFormField<String>(
                                    value: _selectedIl,
                                    decoration: InputDecoration(
                                      labelText: 'İl',
                                      alignLabelWithHint: true,
                                      labelStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    ),
                                    items: _iller
                                        .map((il) => DropdownMenuItem(
                                              value: il,
                                              child: Text(il),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedIl = value;
                                        _selectedIlce = null;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'İl seçilmelidir';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: DropdownButtonFormField<String>(
                              value: _selectedIlce,
                              decoration: InputDecoration(
                                labelText: 'İlçe',
                                alignLabelWithHint: true,
                                labelStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              ),
                              items: (_selectedIl != null)
                                  ? _ilceler[_selectedIl]!
                                      .map((ilce) => DropdownMenuItem(
                                            value: ilce,
                                            child: Text(ilce),
                                          ))
                                      .toList()
                                  : [],
                              onChanged: (value) {
                                setState(() {
                                  _selectedIlce = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'İlçe seçilmelidir';
                                }
                                return null;
                              },
                            ),
                          ),
                          _buildTextField(_adresController, "Adres", maxLines: 2),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: TextFormField(
                              controller: _ihtiyacController,
                              maxLines: 5,
                              decoration: InputDecoration(
                                labelText: "İhtiyaç Açıklaması",
                                alignLabelWithHint: true,
                                labelStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "İhtiyaç Açıklaması boş bırakılamaz";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.grey[700],
                                  side: BorderSide(color: Colors.grey[400]!),
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text("İptal"),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Kişi kaydedildi!")),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.save, size: 20),
                                    SizedBox(width: 8),
                                    Text("Kaydet"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          _buildTextField(_adController, "Ad"),
                          _buildTextField(_soyadController, "Soyad"),
                          _buildTextField(_yasController, "Yaş", keyboardType: TextInputType.number),
                          _buildTextField(_tcController, "TC Kimlik No", keyboardType: TextInputType.number),
                          _buildTextField(_telefonController, "Telefon", keyboardType: TextInputType.phone),
                          _buildTextField(_aileController, "Aile Büyüklüğü", keyboardType: TextInputType.number),
                          _buildTextField(_gelirController, "Aylık Gelir (TL)", keyboardType: TextInputType.number),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: DropdownButtonFormField<String>(
                              value: _selectedIl,
                              decoration: InputDecoration(
                                labelText: 'İl',
                                alignLabelWithHint: true,
                                labelStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              ),
                              items: _iller
                                  .map((il) => DropdownMenuItem(
                                        value: il,
                                        child: Text(il),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedIl = value;
                                  _selectedIlce = null;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'İl seçilmelidir';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: DropdownButtonFormField<String>(
                              value: _selectedIlce,
                              decoration: InputDecoration(
                                labelText: 'İlçe',
                                alignLabelWithHint: true,
                                labelStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              ),
                              items: (_selectedIl != null)
                                  ? _ilceler[_selectedIl]!
                                      .map((ilce) => DropdownMenuItem(
                                            value: ilce,
                                            child: Text(ilce),
                                          ))
                                      .toList()
                                  : [],
                              onChanged: (value) {
                                setState(() {
                                  _selectedIlce = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'İlçe seçilmelidir';
                                }
                                return null;
                              },
                            ),
                          ),
                          _buildTextField(_adresController, "Adres", maxLines: 2),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: TextFormField(
                              controller: _ihtiyacController,
                              maxLines: 5,
                              decoration: InputDecoration(
                                labelText: "İhtiyaç Açıklaması",
                                alignLabelWithHint: true,
                                labelStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "İhtiyaç Açıklaması boş bırakılamaz";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.grey[700],
                                  side: BorderSide(color: Colors.grey[400]!),
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text("İptal"),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Kişi kaydedildi!")),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.save, size: 20),
                                    SizedBox(width: 8),
                                    Text("Kaydet"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          alignLabelWithHint: true,
          labelStyle: const TextStyle(fontSize: 13, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "${label} boş bırakılamaz";
          }
          return null;
        },
      ),
    );
  }
}
