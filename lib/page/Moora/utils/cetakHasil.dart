import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class CetakHasil {
  void getPDF() async {
    try {
      final pdf = pw.Document();

      // Ambil data dari Firebase
      final snapshot =
          await FirebaseFirestore.instance
              .collection('hasil_moora')
              .orderBy('total_nilai', descending: true)
              .get();

      final data = snapshot.docs.map((doc) => doc.data()).toList();

      final imageBytes = await rootBundle.load('assets/images/Logo.png');
      final logoImage = pw.MemoryImage(imageBytes.buffer.asUint8List());

      await initializeDateFormatting('id_ID', null);
      final tanggal = DateFormat('d MMMM y', 'id_ID').format(DateTime.now());

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // HEADER
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      height: 80,
                      width: 80,
                      child: pw.Image(logoImage),
                    ),
                    pw.SizedBox(width: 10),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'PT DOPE STORE',
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            'Komplek, Jl. Delima Cikutra No.83i, Cikutra, Kec. Cibeunying Kidul',
                          ),
                          pw.Text('Kota Bandung, Jawa Barat'),
                          pw.Text('Telp : 081312703384'),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.Divider(thickness: 1),
                pw.SizedBox(height: 10),

                // JUDUL
                pw.Center(
                  child: pw.Text(
                    'Laporan Hasil Perhitungan',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 10),

                // TABEL
                pw.Table.fromTextArray(
                  border: pw.TableBorder.all(width: 1),
                  cellAlignment: pw.Alignment.center,
                  headerDecoration: pw.BoxDecoration(color: PdfColors.black),
                  headerStyle: pw.TextStyle(
                    color: PdfColors.white,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  cellStyle: pw.TextStyle(fontSize: 10),
                  headers: ['Rank', 'Tipe Sepatu', 'Hasil Penilaian'],
                  data: List<List<String>>.generate(
                    data.length,
                    (index) => [
                      (index + 1).toString(),
                      data[index]['tipe'] ?? '',
                      data[index]['total_nilai']?.toString() ?? '',
                    ],
                  ),
                ),

                pw.Spacer(),

                // FOOTER
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      // Gunakan di dalam PDF
                      pw.Text('Bandung, $tanggal'),
                      pw.SizedBox(height: 20),
                      pw.Text('Owner Dope Store'),
                      pw.SizedBox(height: 100),
                      pw.Text('_________________'),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );

      final bytes = await pdf.save();
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/Laporan_Hasil_Perhitungan.pdf');
      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);
    } catch (e, stack) {
      print("ERROR CETAK PDF: $e");
      print("STACK: $stack");
    }
  }
}
