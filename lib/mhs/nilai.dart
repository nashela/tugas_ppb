class Mahasiswa {
  // atribut inisial
  double nilaiTugas, nilaiUts, nilaiUas;
  // atribut komposit
  String? nilaiHuruf, predikat;
  double? pNilaiTugas, pNilaiUts, pNilaiUas, nilaiAkhir;

  Mahasiswa(this.nilaiTugas, this.nilaiUts, this.nilaiUas) {
    hitungNilai();
  }

  void hitungNilai() {
    pNilaiTugas = 35 / 100 * nilaiTugas;
    pNilaiUts = 30 / 100 * nilaiUts;
    pNilaiUas = 35 / 100 * nilaiUas;
    nilaiAkhir = pNilaiTugas! + pNilaiUts! + pNilaiUas!;
    if (nilaiAkhir! > 85) {
      nilaiHuruf = 'A';
      predikat = "Sangat Baik";
    } else if (nilaiAkhir! > 75) {
      nilaiHuruf = 'B';
      predikat = "Baik";
    } else {
      nilaiHuruf = 'C';
      predikat = "Cukup";
    }
  }
}