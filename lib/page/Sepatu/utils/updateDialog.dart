import 'package:flutter/material.dart';
import 'package:spk_app/page/utils/dialogBtn.dart';

// ignore: must_be_immutable
class Updatedialog extends StatefulWidget {
  TextEditingController indexController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController bahanController = TextEditingController();
  TextEditingController ukuranController = TextEditingController();
  TextEditingController warnaController = TextEditingController();
  TextEditingController beratController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  late List newTipeSepatu;
  final List? indexSepatu;
  final VoidCallback? onDataChanged;
  final String? collection;

  Updatedialog({
    super.key,
    this.onDataChanged,
    required this.indexSepatu,
    this.collection,
  }) {
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
  State<Updatedialog> createState() => _UpdatedialogState();
}

class _UpdatedialogState extends State<Updatedialog> {
  int? parseInt;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF4F98CA),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: SizedBox(
        width: double.maxFinite,
        // FIX: Batasi tinggi dialog agar tidak melebihi layar
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            // ==== BAGIAN ATAS TETAP ====
            Text(
              'Ubah Data Sepatu',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFEFFFFB),
              ),
            ),
            Divider(color: Color(0xFFEFFFFB), thickness: 2),
            const SizedBox(height: 10),

            Row(
              children: [
                Text(
                  'Pilih data ke- : ',
                  style: const TextStyle(
                    color: Color(0xFFEFFFFB),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: TextField(
                      controller: widget.indexController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFEFFFFB),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            MaterialButton(
              minWidth: double.infinity,
              onPressed: () {
                widget.namaController.clear();
                widget.bahanController.clear();
                widget.ukuranController.clear();
                widget.warnaController.clear();
                widget.beratController.clear();
                widget.hargaController.clear();

                int? index = int.tryParse(widget.indexController.text);
                if (index != null && index <= widget.indexSepatu!.length) {
                  var data = widget.indexSepatu?[index - 1];
                  widget.namaController.text = data['tipe_sepatu'];
                  widget.bahanController.text = data['bahan'];
                  widget.ukuranController.text = data['jml_size'].toString();
                  widget.warnaController.text = data['jml_warna'].toString();
                  widget.beratController.text = data['berat'].toString();
                  widget.hargaController.text = data['harga'].toString();
                  setState(() {
                    parseInt = index;
                  });
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Data tidak tersedia'),
                      duration: Duration(seconds: 2),
                      backgroundColor: const Color.fromARGB(255, 175, 76, 76),
                    ),
                  );
                }
              },
              height: 40,
              color: const Color(0xFF50D890),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Isi data',
                style: TextStyle(
                  color: Color(0xFFEFFFFB),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(color: Color(0xFFEFFFFB), thickness: 2),

            // ==== SCROLLABLE TEXTFIELDS ====
            Expanded(
              child: ListView.builder(
                itemCount: widget.newTipeSepatu.length,
                itemBuilder: (context, index) {
                  final tipe = widget.newTipeSepatu[index];
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
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ==== BAGIAN BAWAH TETAP ====
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DialogButton(
                  text: "update",
                  docId:
                      parseInt != null && widget.indexSepatu != null
                          ? widget.indexSepatu![parseInt! - 1]['id']
                          : null,
                  namaController: widget.namaController,
                  bahanController: widget.bahanController,
                  ukuranController: widget.ukuranController,
                  warnaController: widget.warnaController,
                  beratController: widget.beratController,
                  hargaController: widget.hargaController,
                  onDataChanged: widget.onDataChanged,
                  idCollection: widget.collection,
                ),
                const SizedBox(width: 10),
                DialogButton(
                  text: "cancel",
                  namaController: widget.namaController,
                  bahanController: widget.bahanController,
                  ukuranController: widget.ukuranController,
                  warnaController: widget.warnaController,
                  beratController: widget.beratController,
                  hargaController: widget.hargaController,
                  onDataChanged: widget.onDataChanged,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
