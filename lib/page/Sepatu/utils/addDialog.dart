import 'package:flutter/material.dart';
import 'package:spk_app/page/utils/dialogBtn.dart';

// ignore: must_be_immutable
class AddDialog extends StatelessWidget {
  TextEditingController namaController = TextEditingController();
  TextEditingController bahanController = TextEditingController();
  TextEditingController ukuranController = TextEditingController();
  TextEditingController warnaController = TextEditingController();
  TextEditingController beratController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  late List newTipeSepatu;
  final VoidCallback? onDataChanged;
  final String? collection;

  AddDialog({super.key, this.onDataChanged, this.collection}) {
    newTipeSepatu = [
      {'nama': 'Nama Tipe Sepatu', 'Controller': namaController},
      {'nama': 'Bahan Sepatu', 'Controller': bahanController},
      {'nama': 'Jumlah Size Sepatu', 'Controller': ukuranController},
      {'nama': 'Jumlah Warna Sepatu', 'Controller': warnaController},
      {'nama': 'Berat Sepatu', 'Controller': beratController},
      {'nama': 'Harga Sepatu', 'Controller': hargaController},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF4F98CA),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Text(
              'Tambah Data Sepatu',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFEFFFFB),
              ),
            ),
            Divider(color: Color(0xFFEFFFFB), thickness: 2),
            const SizedBox(height: 10),

            // Scrollable input
            Expanded(
              child: ListView.builder(
                itemCount: newTipeSepatu.length,
                itemBuilder: (context, index) {
                  final tipe = newTipeSepatu[index];
                  final controller =
                      tipe['Controller'] as TextEditingController;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tipe['nama'],
                          style: const TextStyle(
                            color: Color(0xFFEFFFFB),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          height: 45,
                          child: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFEFFFFB),
                              hintStyle: TextStyle(color: Color(0xFF272727)),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF272727),
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFFEFFFFB),
                                  width: 2,
                                ),
                              ),
                              border: OutlineInputBorder(),
                              hintText:
                                  "Masukkan ${tipe['nama'].toLowerCase()}",
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            // Buttons tetap
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DialogButton(
                  text: "save",
                  namaController: namaController,
                  bahanController: bahanController,
                  ukuranController: ukuranController,
                  warnaController: warnaController,
                  beratController: beratController,
                  hargaController: hargaController,
                  onDataChanged: onDataChanged,
                  idCollection: collection,
                ),
                const SizedBox(width: 10),
                DialogButton(
                  text: "cancel",
                  namaController: namaController,
                  bahanController: bahanController,
                  ukuranController: ukuranController,
                  warnaController: warnaController,
                  beratController: beratController,
                  hargaController: hargaController,
                  onDataChanged: onDataChanged,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
