import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spk_app/page/utils/dialogBtn.dart';

class Dialoghasil extends StatelessWidget {
  const Dialoghasil({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF4F98CA),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      contentPadding: const EdgeInsets.all(0),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF4F98CA),
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: const Text(
                "Hasil Ranking Menggunakan\nMOORA",
                style: TextStyle(
                  color: Color(0xFF272727),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Table Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Rank",
                    style: TextStyle(
                      color: Color(0xFFEFFFFB),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Tipe Sepatu",
                    style: TextStyle(
                      color: Color(0xFFEFFFFB),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Total Nilai",
                    style: TextStyle(
                      color: Color(0xFFEFFFFB),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Color(0xFF272727),
              thickness: 2,
              height: 1,
              indent: 15,
              endIndent: 15,
            ),

            // ListView
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('hasil_moora')
                        .orderBy('total_nilai', descending: true)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text("Belum ada hasil perhitungan."),
                      ),
                    );
                  }

                  final hasilList = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: hasilList.length,
                    itemBuilder: (context, index) {
                      final data =
                          hasilList[index].data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${index + 1}",
                              style: TextStyle(
                                color: Color(0xFFEFFFFB),
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              data['tipe'] ?? '-',
                              style: const TextStyle(
                                color: Color(0xFFEFFFFB),
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "${data['total_nilai'] ?? 0.0}",
                              style: TextStyle(
                                color: Color(0xFFEFFFFB),
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Tombol cancel presisi kanan bawah
            SizedBox(height: 50),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 15, top: 4),
                child: SizedBox(
                  height: 36,
                  width: 120, // tombol fix width
                  child: DialogButton(text: "cancel"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
