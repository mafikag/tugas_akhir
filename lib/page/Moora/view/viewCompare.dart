import 'package:flutter/material.dart';
import 'package:spk_app/page/Moora/view/viewHitung.dart';

// ignore: must_be_immutable
class ViewCompare extends StatelessWidget {
  TextEditingController jumlah = TextEditingController();
  ViewCompare({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFFFFB),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Masukan jumlah sepatu yang ingin di bandingkan',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: jumlah,
                textAlign: TextAlign.center,
                maxLength: 1,
                buildCounter: (
                  BuildContext context, {
                  required int currentLength,
                  required bool isFocused,
                  required int? maxLength,
                }) {
                  return null; // Menghilangkan counter
                },
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF272727), width: 2),
                  ),
                ),
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4F98CA),
                padding: EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                shadowColor: Colors.black,
                elevation: 0,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            Viewhitung(jumlah: int.tryParse(jumlah.text) ?? 0),
                  ),
                );
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Selanjutnya',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFEFFFFB),
                      ),
                    ),
                    Icon(
                      Icons.arrow_circle_right_sharp,
                      size: 25,
                      color: const Color(0xFFEFFFFB),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
