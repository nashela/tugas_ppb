import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'calculator.dart';
import 'mhs/formulir_nilai.dart';

void main() => runApp(const ProfilApp());

class ProfilApp extends StatelessWidget {
  const ProfilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profil Saya',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const ProfilPage(),
    );
  }
}

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  // Menampilkan pesan singkat di bagian bawah layar
  void _tampilPesan(BuildContext context, String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pesan)),
    );
  }

  // Nomor WhatsApp: format internasional, tanpa tanda + dan tanpa 0 di depan
  // Contoh: 0812-3456-7890 menjadi 6281234567890
  static const String _nomorWa = '6285602004718';
  static const String _pesanAwal = 'Halo, saya melihat profil Anda.';

  // Membuka WhatsApp (aplikasi di HP, atau WhatsApp Web di browser)
  Future<void> _bukaWhatsApp(BuildContext context) async {
    final uri = Uri.parse(
      'https://wa.me/$_nomorWa?text=${Uri.encodeComponent(_pesanAwal)}',
    );

    final berhasil = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!berhasil && context.mounted) {
      _tampilPesan(context, 'Tidak dapat membuka WhatsApp');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya'), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Foto profil
              const CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage('assets/images/bear.png'),
              ),
              const SizedBox(height: 20),

              // Nama dan NIM
              const Text(
                'Nashela Zahra',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'NIM: A11.2024.15711',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Program studi dan hobi
              const SizedBox(
                width: 340,
                child: Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.school),
                        title: Text('Program Studi'),
                        subtitle: Text('Teknik Informatika'),
                      ),
                      Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.favorite),
                        title: Text('Hobi'),
                        subtitle: Text('Membaca, bersepeda, ngoding'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Dua tombol
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _bukaWhatsApp(context),
                    icon: const Icon(Icons.call),
                    label: const Text('Hubungi'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FormulirNilai()),
                    );
                  }, child: const Text('Form Nilai')
                  ),
                  // OutlinedButton.icon(
                  //   onPressed: () => _tampilPesan(context, 'Tombol Bagikan ditekan'),
                  //   icon: const Icon(Icons.share),
                  //   label: const Text('Bagikan'),
                  // ),
                  const SizedBox(width: 12),
                  FilledButton.icon(onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CalculatorApp())
                    );
                  }, label: const Text('Kalkulator'), icon: const Icon(Icons.calculate))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}