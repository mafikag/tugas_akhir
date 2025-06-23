import 'package:flutter/material.dart';
import 'package:spk_app/page/utils/dialogBtn.dart';

// ignore: must_be_immutable
class dialogLogOut extends StatefulWidget {
  const dialogLogOut({super.key});

  @override
  State<dialogLogOut> createState() => _dialogLogOutState();
}

class _dialogLogOutState extends State<dialogLogOut> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF4F98CA),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: SizedBox(
        width: double.maxFinite,
        // FIX: Batasi tinggi dialog agar tidak melebihi layar
        height: MediaQuery.of(context).size.height * 0.14,
        child: Column(
          children: [
            Column(
              children: [
                Text(
                  'Apakah anda ingin logout?',
                  style: const TextStyle(
                    color: Color(0xFFEFFFFB),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DialogButton(text: "logout"),
                    const SizedBox(width: 10),
                    DialogButton(text: "cancel"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
