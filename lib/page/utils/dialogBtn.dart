import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spk_app/Controller/ControlAuthPage.dart';
import 'package:spk_app/page/Sepatu/utils/konfirDeleteDialog.dart';

// ignore: must_be_immutable
class DialogButton extends StatelessWidget {
  String text;
  final VoidCallback? onDataChanged;
  final String? idCollection;
  final String? docId;
  TextEditingController? namaController = TextEditingController();
  TextEditingController? bahanController = TextEditingController();
  TextEditingController? ukuranController = TextEditingController();
  TextEditingController? warnaController = TextEditingController();
  TextEditingController? beratController = TextEditingController();
  TextEditingController? hargaController = TextEditingController();
  DialogButton({
    super.key,
    this.idCollection,
    this.docId,
    required this.text,
    this.onDataChanged,
    this.namaController,
    this.bahanController,
    this.ukuranController,
    this.warnaController,
    this.beratController,
    this.hargaController,
  });

  IconData icon(String text) {
    if (text == "save") {
      return Icons.save;
    } else if (text == "update") {
      return Icons.edit_document;
    } else if (text == "delete") {
      return Icons.delete;
    } else if (text == 'logout') {
      return Icons.logout_rounded;
    } else if (text == 'yes, delete!') {
      return Icons.delete;
    } else {
      return Icons.clear;
    }
  }

  Future addUser(
    String nama,
    String bahan,
    String size,
    String warna,
    String berat,
    String harga,
  ) async {
    // Jika username belum ada, tambahkan ke Firestore
    await FirebaseFirestore.instance.collection(idCollection!).add({
      'tipe_sepatu': nama,
      'bahan': bahan,
      'jml_size': int.parse(size),
      'jml_warna': int.parse(warna),
      'berat': int.parse(berat),
      'harga': int.parse(harga),
    });
  }

  Future updateUser(
    String nama,
    String bahan,
    String size,
    String warna,
    String berat,
    String harga,
  ) async {
    // Jika username belum ada, tambahkan ke Firestore
    await FirebaseFirestore.instance
        .collection(idCollection!)
        .doc(docId)
        .update({
          'tipe_sepatu': nama,
          'bahan': bahan,
          'jml_size': int.parse(size),
          'jml_warna': int.parse(warna),
          'berat': int.parse(berat),
          'harga': int.parse(harga),
        });
  }

  Future deleteBtn() async {
    await FirebaseFirestore.instance
        .collection(idCollection!)
        .doc(docId)
        .delete()
        .then((_) {
          print("Berhasil dihapus");
        })
        // ignore: invalid_return_type_for_catch_error
        .catchError((e) => print('Gagal hapus: $e'));
  }

  void clearText() {
    namaController!.clear();
    bahanController!.clear();
    ukuranController!.clear();
    warnaController!.clear();
    beratController!.clear();
    hargaController!.clear();
  }

  Future<void> onPressedAdd() async {
    // Ambil nilai dari TextEditingController
    String nama = namaController!.text.trim();
    String bahan = bahanController!.text.trim();
    String size = ukuranController!.text.trim();
    String warna = warnaController!.text.trim();
    String berat = beratController!.text.trim();
    String harga = hargaController!.text.trim();

    // Panggil fungsi untuk menambahkan data ke Firestore
    await addUser(nama, bahan, size, warna, berat, harga);
  }

  Future<void> onPressedUpdate() async {
    // Ambil nilai dari TextEditingController
    String nama = namaController!.text.trim();
    String bahan = bahanController!.text.trim();
    String size = ukuranController!.text.trim();
    String warna = warnaController!.text.trim();
    String berat = beratController!.text.trim();
    String harga = hargaController!.text.trim();

    // Panggil fungsi untuk menambahkan data ke Firestore
    await updateUser(nama, bahan, size, warna, berat, harga);
  }

  void onClicked(BuildContext context) {
    // Jika teks adalah "save", simpan data
    if (text == "save") {
      onPressedAdd();
      clearText();
      if (onDataChanged != null) {
        onDataChanged!(); // Panggil callback jika ada
      }
      Navigator.pop(context);
    } else if (text == 'update') {
      onPressedUpdate();
      clearText();
      if (onDataChanged != null) {
        onDataChanged!(); // Panggil callback jika ada
      }
      Navigator.pop(context);
    } else if (text == 'delete') {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) {
          return KonfirDeleteDialog(
            idCollection: idCollection!,
            onDataChanged: onDataChanged,
            docId: docId!,
          );
        },
      );
    } else if (text == 'logout') {
      FirebaseAuth.instance.signOut().then((_) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder:
                (context, animation, secondaryAnimation) =>
                    ControlAuthPage(selectedIndex: 0), // Ganti sesuai tujuan
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              final beginScale = 1.5;
              final endScale = 1.0;

              final fadeIn = CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              );

              return FadeTransition(
                opacity: fadeIn,
                child: ScaleTransition(
                  scale: Tween<double>(
                    begin: beginScale,
                    end: endScale,
                  ).animate(fadeIn),
                  child: child,
                ),
              );
            },
          ),
        );
      });
    } else if (text == 'yes, delete!') {
      deleteBtn();
      if (onDataChanged != null) {
        onDataChanged!(); // Panggil callback jika ada
      }
      Navigator.pop(context);
    } else {
      //buat close
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => onClicked(context),
      height: 40,
      disabledColor:
          text != 'yes, delete!' ? Color(0xFF50D890) : Color(0xFFEB5353),
      color: text != 'yes, delete!' ? Color(0xFF50D890) : Color(0xFFEB5353),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          text != 'yes, delete!'
              ? Icon(icon(text), color: Color(0xFFEFFFFB))
              : //Icon(null),
              const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color:
                  text != 'yes, delete!'
                      ? Color(0xFFEFFFFB)
                      : Color(0xFF272727),
              fontSize: text != 'yes, delete!' ? 16 : 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
