import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  // Statik iller ve ilçeler
  final Map<String, List<String>> _ilceler = {
    'İstanbul': ['beylikduzu', 'Beşiktaş', 'Üsküdar'],
    'Ankara': ['sincan', 'Keçiören', 'Yenimahalle'],
    'İzmir': ['Konak', 'Bornova', 'Karşıyaka'],
  };
  String? _selectedSehir;
  String? _selectedIlce;

  // Eklenen kişiler ilçeye göre gruplanacak
  // final Map<String, List<Map<String, String>>> _ilceyeGoreKisiler = {};

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

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black54,
                size: 20,
              ),
              onPressed: () => Navigator.of(context).maybePop(),
              tooltip: 'Geri Dön',
            ),
            const SizedBox(width: 4),
            Container(
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
            const SizedBox(width: 12),
            const Text(
              "Yeni Kişi Ekle",
              style: TextStyle(
                color: Color(0xFF1976D2),
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 28,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      const Text(
                        "Kişi Bilgileri",
                        style: TextStyle(
                          color: Color(0xFF1976D2),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 18),
                      isWide
                          ? Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(_adController, "Ad"),
                                ),
                                const SizedBox(width: 18),
                                Expanded(
                                  child: _buildTextField(
                                    _soyadController,
                                    "Soyad",
                                  ),
                                ),
                              ],
                            )
                          : _buildTextField(_adController, "Ad"),
                      isWide
                          ? Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    _yasController,
                                    "Yaş",
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 18),
                                Expanded(
                                  child: _buildTextField(
                                    _tcController,
                                    "TC Kimlik No",
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            )
                          : _buildTextField(_soyadController, "Soyad"),
                      isWide
                          ? Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    _telefonController,
                                    "Telefon",
                                    keyboardType: TextInputType.phone,
                                  ),
                                ),
                                const SizedBox(width: 18),
                                Expanded(
                                  child: _buildTextField(
                                    _aileController,
                                    "Aile Büyüklüğü",
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            )
                          : _buildTextField(
                              _yasController,
                              "Yaş",
                              keyboardType: TextInputType.number,
                            ),
                      isWide
                          ? Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    _gelirController,
                                    "Aylık Gelir (TL)",
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 18),
                                Expanded(child: _buildDropdownIl()),
                              ],
                            )
                          : _buildTextField(
                              _tcController,
                              "TC Kimlik No",
                              keyboardType: TextInputType.number,
                            ),
                      if (!isWide)
                        _buildTextField(
                          _telefonController,
                          "Telefon",
                          keyboardType: TextInputType.phone,
                        ),
                      if (!isWide)
                        _buildTextField(
                          _aileController,
                          "Aile Büyüklüğü",
                          keyboardType: TextInputType.number,
                        ),
                      if (!isWide)
                        _buildTextField(
                          _gelirController,
                          "Aylık Gelir (TL)",
                          keyboardType: TextInputType.number,
                        ),
                      if (!isWide) _buildDropdownIl(),
                      _buildDropdownIlce(),
                      _buildTextField(_adresController, "Adres", maxLines: 2),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TextFormField(
                          controller: _ihtiyacController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: "İhtiyaç Açıklaması",
                            alignLabelWithHint: true,
                            labelStyle: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF757575),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF1976D2),
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 18,
                            ),
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
                              side: BorderSide(color: Colors.grey[400]!, width: 1.2),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 18,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              elevation: 0,
                            ),
                            child: const Text("İptal"),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            height: 38,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (_selectedSehir == null ||
                                      _selectedIlce == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'İl ve ilçe seçilmelidir! ',
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  final sehirNorm = normalize(_selectedSehir!);
                                  final ilceNorm = normalize(_selectedIlce!);
                                  final kisiData = {
                                    'isim': _adController.text,
                                    'soyad': _soyadController.text,
                                    'yas': _yasController.text,
                                    'tc': _tcController.text,
                                    'telefon': _telefonController.text,
                                    'aile': _aileController.text,
                                    'gelir': _gelirController.text,
                                    'adres': _adresController.text,
                                    'ihtiyac': _ihtiyacController.text,
                                    'il': _selectedSehir ?? '',
                                    'ilce': _selectedIlce ?? '',
                                    'sontarih': FieldValue.serverTimestamp(),
                                    'sonaciklama': _ihtiyacController.text,
                                  };
                                  try {
                                    await FirebaseFirestore.instance
                                        .collection('bolgeler')
                                        .doc(sehirNorm)
                                        .collection(ilceNorm)
                                        .add(kisiData);
                                    _adController.clear();
                                    _soyadController.clear();
                                    _yasController.clear();
                                    _tcController.clear();
                                    _telefonController.clear();
                                    _aileController.clear();
                                    _gelirController.clear();
                                    _adresController.clear();
                                    _ihtiyacController.clear();
                                    setState(() {
                                      _selectedSehir = null;
                                      _selectedIlce = null;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Kişi başarıyla eklendi!',
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Hata: $e')),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 22,
                                ),
                                elevation: 0,
                                backgroundColor: const Color(0xFF1976D2),
                                foregroundColor: Colors.white,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.save,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "Kaydet",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
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
      ),
    );
  }

  Widget _buildDropdownIl() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: _selectedSehir,
        decoration: InputDecoration(
          labelText: 'İl',
          alignLabelWithHint: true,
          labelStyle: const TextStyle(fontSize: 13, color: Color(0xFF757575)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        items: _ilceler.keys
            .map((il) => DropdownMenuItem(value: il, child: Text(il)))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedSehir = value;
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
    );
  }

  Widget _buildDropdownIlce() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: _selectedIlce,
        decoration: InputDecoration(
          labelText: 'İlçe',
          alignLabelWithHint: true,
          labelStyle: const TextStyle(fontSize: 13, color: Color(0xFF757575)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        items: (_selectedSehir != null ? _ilceler[_selectedSehir] ?? [] : [])
            .map<DropdownMenuItem<String>>(
              (ilce) =>
                  DropdownMenuItem<String>(value: ilce, child: Text(ilce)),
            )
            .toList(),
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
          labelStyle: const TextStyle(fontSize: 13, color: Color(0xFF757575)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
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
