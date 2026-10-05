import 'package:flutter/material.dart';
import 'nilai.dart';

class FormulirNilai extends StatefulWidget {
  const FormulirNilai({super.key});

  @override
  State<FormulirNilai> createState() => _FormulirNilaiState();
}

class _FormulirNilaiState extends State<FormulirNilai> {
  final tugasController = TextEditingController(text: '0');
  final utsController = TextEditingController(text: '0');
  final uasController = TextEditingController(text: '0');
  
  late Mahasiswa mhs;

  @override
  void initState() {
    super.initState();
    // Inisialisasi object Mahasiswa
    mhs = Mahasiswa(0, 0, 0);
  }

  @override
  void dispose() {
    tugasController.dispose();
    utsController.dispose();
    uasController.dispose();
    super.dispose();
  }

  void updateNilai(String key, double value) {
    setState(() {
      switch (key) {
        case "tugas":
          mhs.nilaiTugas = value;
          break;
        case "uts":
          mhs.nilaiUts = value;
          break;
        case "uas":
          mhs.nilaiUas = value;
          break;
      }
      mhs.hitungNilai();
    });
  }

  @override
  Widget build(BuildContext context) {
    // WAJIB menggunakan Scaffold agar halaman hasil push Navigator punya struktur layout yang benar
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulir Nilai Mahasiswa'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            TextField(
              controller: tugasController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                updateNilai("tugas", double.tryParse(value) ?? 0.0);
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Nilai Tugas",
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: utsController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                updateNilai("uts", double.tryParse(value) ?? 0.0);
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Nilai UTS",
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: uasController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                updateNilai("uas", double.tryParse(value) ?? 0.0);
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Nilai UAS",
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            
            // Bagian Hasil Output
            Text("Nilai Akhir", style: Theme.of(context).textTheme.labelLarge),
            Text("${mhs.nilaiAkhir}", style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            
            Text("Nilai Huruf", style: Theme.of(context).textTheme.labelLarge),
            Text("${mhs.nilaiHuruf}", style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            
            Text("Predikat", style: Theme.of(context).textTheme.labelLarge),
            Text("${mhs.predikat}", style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}