import 'package:flutter/material.dart';
import 'package:spk_app/page/Moora/utils/cetakHasil.dart';
import 'package:spk_app/page/Moora/utils/dropDown.dart';

class Viewhitung extends StatefulWidget {
  final int jumlah;
  const Viewhitung({super.key, required this.jumlah});

  @override
  State<Viewhitung> createState() => _ViewhitungState();
}

class _ViewhitungState extends State<Viewhitung> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 255, 251),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFFFFB),
        elevation: 0,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.close_rounded, color: Color(0xFF272727)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  'Hitung',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.print_rounded, color: Color(0xFF272727)),
                  onPressed: () {
                    // print('Print functionality not implemented yet');
                    CetakHasil().getPDF();
                  },
                ),
                // const SizedBox(width: 10),
                // IconButton(
                //   icon: Icon(Icons.print, color: Color(0xFF272727)),
                //   onPressed: () {
                //     print('Print functionality not implemented yet');
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(child: Dropdown(jml_dropdown: widget.jumlah)),
    );
  }
}
