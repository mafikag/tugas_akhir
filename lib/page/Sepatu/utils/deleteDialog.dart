import 'package:flutter/material.dart';
import 'package:spk_app/page/utils/dialogBtn.dart';

// ignore: must_be_immutable
class Deletedialog extends StatefulWidget {
  TextEditingController indexController = TextEditingController();
  String nama = '';
  String bahan = '';
  String ukuran = '';
  String warna = '';
  String berat = '';
  String harga = '';
  late List newTipeSepatu;
  final List? indexSepatu;
  final VoidCallback? onDataChanged;
  final String? collection;

  Deletedialog({
    super.key,
    this.onDataChanged,
    required this.indexSepatu,
    this.collection,
  }) {
    newTipeSepatu = [
      {'nama': 'Nama Tipe Sepatu :', 'Isi': nama},
      {'nama': 'Bahan Sepatu :', 'Isi': bahan},
      {'nama': 'Jumlah Size Sepatu :', 'Isi': ukuran},
      {'nama': 'Jumlah Warna Sepatu :', 'Isi': warna},
      {'nama': 'Berat Sepatu :', 'Isi': berat},
      {'nama': 'Harga Sepatu :', 'Isi': harga},
    ];
  }

  @override
  State<Deletedialog> createState() => _DeletedialogState();
}

class _DeletedialogState extends State<Deletedialog> {
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
              'Hapus Data Sepatu',
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
                int? index = int.tryParse(widget.indexController.text);
                if (index != null && index <= widget.indexSepatu!.length) {
                  var data = widget.indexSepatu?[index - 1];
                  widget.nama = data['tipe_sepatu'];
                  widget.bahan = data['bahan'];
                  widget.ukuran = data['jml_size'].toString();
                  widget.warna = data['jml_warna'].toString();
                  widget.berat = data['berat'].toString();
                  widget.harga = data['harga'].toString();

                  widget.newTipeSepatu = [
                    {'nama': 'Nama Tipe Sepatu :', 'Isi': widget.nama},
                    {'nama': 'Bahan Sepatu :', 'Isi': widget.bahan},
                    {'nama': 'Jumlah Size Sepatu :', 'Isi': widget.ukuran},
                    {'nama': 'Jumlah Warna Sepatu :', 'Isi': widget.warna},
                    {'nama': 'Berat Sepatu :', 'Isi': widget.berat},
                    {'nama': 'Harga Sepatu :', 'Isi': widget.harga},
                  ];

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
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          tipe['Isi'],
                          style: const TextStyle(
                            color: Color(0xFFEFFFFB),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
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
                  text: "delete",
                  onDataChanged: widget.onDataChanged,
                  idCollection: widget.collection,
                  docId:
                      parseInt != null && widget.indexSepatu != null
                          ? widget.indexSepatu![parseInt! - 1]['id']
                          : null,
                ),
                const SizedBox(width: 10),
                DialogButton(
                  text: "cancel",
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
