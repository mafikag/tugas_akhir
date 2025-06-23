import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Map<String, dynamic>>> hitungSepatu(List<String> pilihan) async {
  // 🔥 Hapus dulu isi koleksi 'hasil_moora'
  await _hapusDataHasilMoora();

  List<Map<String, dynamic>> alternatif = [];

  final bobot = {'C1': 0.25, 'C2': 0.2, 'C3': 0.2, 'C4': 0.15, 'C5': 0.2};

  final bahanRanking = {
    'Leather': 5,
    'Denim': 4,
    'Rubber': 3,
    'Kanvas': 2,
    'Knit': 1,
  };

  for (var item in pilihan) {
    try {
      final parts = item.split(' ');
      final koleksi = parts[0];
      final tipe = parts.sublist(1).join(' ');

      final snap =
          await FirebaseFirestore.instance
              .collection(koleksi)
              .where('tipe_sepatu', isEqualTo: tipe)
              .limit(1)
              .get();

      if (snap.docs.isEmpty) {
        print('⚠️ Tidak ditemukan sepatu: $koleksi - $tipe');
        continue;
      }

      final data = snap.docs.first.data();

      alternatif.add({
        'tipe': data['tipe_sepatu'] ?? '-',
        'C1': double.tryParse(data['harga']?.toString() ?? '') ?? 0.0,
        'C2': double.tryParse(data['berat']?.toString() ?? '') ?? 0.0,
        'C3': bahanRanking[data['bahan']]?.toDouble() ?? 0.0,
        'C4': double.tryParse(data['jml_size']?.toString() ?? '') ?? 0.0,
        'C5': double.tryParse(data['jml_warna']?.toString() ?? '') ?? 0.0,
      });
    } catch (e) {
      print('❌ Gagal mengambil data sepatu: $item | Error: $e');
    }
  }

  if (alternatif.isEmpty) {
    throw Exception("Tidak ada data sepatu valid ditemukan.");
  }

  // 🔢 Hitung nilai pembagi untuk normalisasi
  Map<String, double> pembagi = {};
  for (var k in bobot.keys) {
    final total = alternatif
        .map((a) => a[k] ?? 0.0)
        .map((n) => n * n)
        .reduce((a, b) => a + b);

    pembagi[k] = sqrt(total);
    if (pembagi[k] == 0) pembagi[k] = 1e-6; // hindari pembagian nol
  }

  // ✅ Hitung skor MOORA untuk masing-masing alternatif
  List<Map<String, dynamic>> hasil = [];
  for (var alt in alternatif) {
    double benefit = 0.0;
    double cost = 0.0;
    for (var k in bobot.keys) {
      final nilai = alt[k] ?? 0.0;
      final normal = nilai / pembagi[k]!;

      if (k == 'C1' || k == 'C2') {
        cost += normal * bobot[k]!;
      } else {
        benefit += normal * bobot[k]!;
      }
    }

    hasil.add({
      'tipe': alt['tipe'],
      'total_nilai': double.parse((benefit - cost).toStringAsFixed(5)),
      'timestamp': Timestamp.now(),
    });
  }

  return hasil;
}

// 🧹 Fungsi untuk menghapus semua data dari koleksi hasil_moora
Future<void> _hapusDataHasilMoora() async {
  final snapshot =
      await FirebaseFirestore.instance.collection('hasil_moora').get();

  for (var doc in snapshot.docs) {
    await doc.reference.delete();
  }

  print('🗑️ Koleksi hasil_moora dibersihkan sebelum simpan baru.');
}
