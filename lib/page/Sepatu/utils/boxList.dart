import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BoxList extends StatefulWidget {
  final String title;
  final String material;
  final String totalSize;
  final String totalVariant;
  final String weight;
  final String price;
  final int index;
  const BoxList({
    super.key,
    required this.title,
    required this.material,
    required this.totalSize,
    required this.totalVariant,
    required this.weight,
    required this.price,
    required this.index,
  });

  @override
  State<BoxList> createState() => _BoxListState();
}

class _BoxListState extends State<BoxList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.19,
      width: MediaQuery.of(context).size.width * 0.9,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Color(0xFF4F98CA),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${widget.index.toString()}.',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Color(0xFFEFFFFB),
              ),
            ),
            SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Color(0xFFEFFFFB),
                ),
              ),
            ),
            Row(
              children: [
                VerticalDivider(
                  color: Color(0xFFEFFFFB),
                  thickness: 1,
                  width:
                      20, // total lebar area divider, termasuk spasi di sekeliling garis
                  indent: 10,
                  endIndent: 10,
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      'Bahan : ${widget.material}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Color(0xFFEFFFFB),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Total size: ${widget.totalSize}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Color(0xFFEFFFFB),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Total varian: ${widget.totalVariant}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Color(0xFFEFFFFB),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Berat : ${widget.weight} gram',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Color(0xFFEFFFFB),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Harga : Rp ${NumberFormat.decimalPattern('id_ID').format(int.tryParse(widget.price) ?? 0)}.000',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Color(0xFFEFFFFB),
                      ),
                    ),
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
