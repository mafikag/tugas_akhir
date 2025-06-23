import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:spk_app/page/utils/dialogBtn.dart';

class KonfirDeleteDialog extends StatefulWidget {
  final VoidCallback? onDataChanged;
  final String idCollection;
  final String docId;

  const KonfirDeleteDialog({
    super.key,
    required this.idCollection,
    required this.docId,
    this.onDataChanged,
  });

  @override
  State<KonfirDeleteDialog> createState() => _KonfirDeleteDialogState();
}

class _KonfirDeleteDialogState extends State<KonfirDeleteDialog> {
  String? tipeSepatu;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTipeSepatu();
  }

  Future<void> _loadTipeSepatu() async {
    try {
      final docSnapshot =
          await FirebaseFirestore.instance
              .collection(widget.idCollection)
              .doc(widget.docId)
              .get();

      if (docSnapshot.exists) {
        setState(() {
          tipeSepatu = docSnapshot.data()?['tipe_sepatu'] ?? '-';
          isLoading = false;
        });
      } else {
        setState(() {
          tipeSepatu = '(data tidak ditemukan)';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        tipeSepatu = '(gagal memuat data)';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF4F98CA),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.18,
        child:
            isLoading
                ? Center(
                  child: Lottie.asset(
                    'assets/animation/Loading.json',
                    width: 500,
                    height: 500,
                    repeat: true,
                    reverse: false,
                    animate: true,
                  ),
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Apakah anda ingin menghapus data sepatu "$tipeSepatu"?',
                      style: const TextStyle(
                        color: Color(0xFFEFFFFB),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: DialogButton(
                            text: "yes, delete!",
                            onDataChanged: widget.onDataChanged,
                            idCollection: widget.idCollection,
                            docId: widget.docId,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: DialogButton(text: "cancel")),
                      ],
                    ),
                  ],
                ),
      ),
    );
  }
}
