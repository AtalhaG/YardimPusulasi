import 'package:flutter/material.dart';

import 'yeni_kisi_ekle.dart';
import '../kisisel_data.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'siralama.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
=======
  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),

      );
      // Başarılı girişte yönlendirme
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SiralamaPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Bir hata oluştu. Lütfen tekrar deneyin.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
      backgroundColor: const Color.fromARGB(255, 213, 222, 245),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Kutu arka planı beyaz
                borderRadius: const BorderRadius.all(Radius.circular(40)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(24, 36, 24, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Yardım Pusulası',
                    style: TextStyle(
                      color: Color(0xFF1976D2), // Mavi başlık
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Daha fazla hayata dokunmak için doğru adresiniz burası.',
                    style: TextStyle(
                      color: Color(0xFF757575), // Açık gri/kırık beyaz açıklama
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(
                      color: Color(0xFF212121),
                    ), // Koyu yazı
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white, // İç beyaz
                      hintText: 'Email',
                      hintStyle: const TextStyle(
                        color: Color(0xFFBDBDBD),
                      ), // Açık gri ipucu
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF1976D2),
                        ), // Mavi çerçeve
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

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF1976D2)),

                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF1976D2),
                          width: 2,
                        ),
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
=======
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (_) => setState(() {}), // Buton aktifliği için
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: _isObscure,
                    style: const TextStyle(color: Color(0xFF212121)),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Şifre',
                      hintStyle: const TextStyle(color: Color(0xFFBDBDBD)),
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
                        borderSide: const BorderSide(
                          color: Color(0xFF1976D2),
                          width: 2,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility,
                          color: const Color(0xFF1976D2),
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),
                    onChanged: (_) => setState(() {}), // Buton aktifliği için
                  ),
                  const SizedBox(height: 24),
                  if (_errorMessage != null) ...[
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,

                    ),
                    const SizedBox(height: 12),
                  ],
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed:
                          (_emailController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty &&
                              !_isLoading)
                          ? _signIn
                          : null,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.zero,
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
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

                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF1976D2), // Mavi
                              Color(0xFF64B5F6), // Açık mavi
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'Giriş Yap',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Hesap Oluşturmak için ',
                        style: TextStyle(color: Color(0xFF757575)),
                      ),
                      GestureDetector(
                        onTap: () {
                          // iletişime geç aksiyonu
                        },
                        child: const Text(
                          'iletişime geç',
                          style: TextStyle(
                            color: Color(0xFF1976D2),
                            fontWeight: FontWeight.bold,
                          ),

                        ),
                      ),
                    ],
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

                ],

              ),
            ),
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
