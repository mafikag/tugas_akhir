import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> cekDataSepatuTidakLengkap() async {
  final List<String> koleksiList = ['compass', 'kanky', 'patrobas'];
  final List<String> fieldWajib = [
    'tipe_sepatu',
    'harga',
    'berat',
    'bahan',
    'jumlah_ukuran',
    'jumlah_warna',
  ];

  for (String koleksi in koleksiList) {
    final snapshot = await FirebaseFirestore.instance.collection(koleksi).get();

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final tipe = data['tipe_sepatu'] ?? '(tanpa tipe)';
      final List<String> fieldKosong = [];

      for (String field in fieldWajib) {
        if (!data.containsKey(field) ||
            data[field] == null ||
            data[field].toString().trim().isEmpty) {
          fieldKosong.add(field);
        }
      }

      if (fieldKosong.isNotEmpty) {
        print(
          '⚠️ Data tidak lengkap di koleksi "$koleksi", tipe "$tipe": Missing ${fieldKosong.join(", ")}',
        );
      }
    }
  }
}
