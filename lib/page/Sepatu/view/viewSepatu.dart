import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:spk_app/page/Sepatu/utils/boxList.dart';
import 'package:spk_app/page/Sepatu/utils/addDialog.dart';
import 'package:spk_app/page/Sepatu/utils/cetakData.dart';
import 'package:spk_app/page/Sepatu/utils/deleteDialog.dart';
import 'package:spk_app/page/Sepatu/utils/searchBar.dart';
import 'package:spk_app/page/Sepatu/utils/updateDialog.dart';

class ViewSepatu extends StatefulWidget {
  final String idCollection;
  const ViewSepatu({super.key, required this.idCollection});

  @override
  State<ViewSepatu> createState() => _ViewSepatuState();
}

class _ViewSepatuState extends State<ViewSepatu> {
  List? userData;
  List? searchData;
  bool visible = false;

  Future<void> _fetchUserData() async {
    final data =
        await FirebaseFirestore.instance.collection(widget.idCollection).get();
    if (data.docs.isNotEmpty) {
      final dataUser =
          data.docs.map((doc) {
            final sepatu = doc.data();
            sepatu['id'] = doc.id; // Simpan doc.id ke data
            return sepatu;
          }).toList();

      setState(() {
        userData = dataUser;
        searchData = dataUser;
      });
    }
  }

  Future roleCheck() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: user.email)
              .get();

      if (doc.docs.isNotEmpty) {
        final data = doc.docs.first.data();
        if (data['role'] == 'admin') {
          return visible = true;
        }
      }
    }
    return visible = false;
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    roleCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        visible: visible,
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: const Color(0xFF50D890),
        foregroundColor: const Color(0xFF272727),
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        childrenButtonSize: const Size(60, 60),
        iconTheme: const IconThemeData(size: 30),
        spaceBetweenChildren: 10,
        spacing: 5,
        children: [
          SpeedDialChild(
            backgroundColor: const Color(0xFF70A1D7),
            child: const Icon(Icons.add, color: Color(0xFF272727)),
            label: 'Tambah Data',
            labelBackgroundColor: const Color(0xFFEFFFFB),
            labelStyle: const TextStyle(
              color: Color(0xFF272727),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
            shape: const CircleBorder(),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AddDialog(
                    onDataChanged: () {
                      _fetchUserData(); // akan dipanggil setelah data berhasil disimpan
                    },
                    collection: widget.idCollection,
                  );
                },
              );
            },
          ),
          SpeedDialChild(
            backgroundColor: const Color(0xFFFCE38A),
            child: const Icon(Icons.edit_document, color: Color(0xFF272727)),
            label: 'Modifikasi Data',
            labelBackgroundColor: const Color(0xFFEFFFFB),
            labelStyle: const TextStyle(
              color: Color(0xFF272727),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
            shape: const CircleBorder(),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Updatedialog(
                    onDataChanged: () {
                      _fetchUserData(); // akan dipanggil setelah data berhasil disimpan
                    },
                    indexSepatu: userData,
                    collection: widget.idCollection,
                  );
                },
              );
            },
          ),
          SpeedDialChild(
            backgroundColor: const Color(0xFFF47C7C),
            child: const Icon(Icons.delete, color: Color(0xFF272727)),
            label: 'Delete Data',
            labelBackgroundColor: const Color(0xFFEFFFFB),
            labelStyle: const TextStyle(
              color: Color(0xFF272727),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
            shape: const CircleBorder(),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Deletedialog(
                    onDataChanged: () {
                      _fetchUserData(); // akan dipanggil setelah data berhasil disimpan
                    },
                    indexSepatu: userData,
                    collection: widget.idCollection,
                  );
                },
              );
            },
          ),
          SpeedDialChild(
            backgroundColor: const Color(0xFF50D890),
            child: const Icon(Icons.print, color: Color(0xFF272727)),
            label: 'Print Data',
            labelBackgroundColor: const Color(0xFFEFFFFB),
            labelStyle: const TextStyle(
              color: Color(0xFF272727),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
            shape: const CircleBorder(),
            onTap: () {
              Cetakdata().getPDF(widget.idCollection);
            },
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFFFFB),
        elevation: 0,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Color(0xFF272727),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SearchBarView(
                      items: userData ?? [],
                      onSearchChanged: (results) {
                        setState(() {
                          searchData = results;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: const Color.fromARGB(255, 239, 255, 251),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Add your Sepatu list or grid here
                ListView.builder(
                  itemCount: searchData?.length ?? 0,
                  shrinkWrap: true, // penting!
                  physics:
                      NeverScrollableScrollPhysics(), // agar tidak scroll di dalam scroll
                  itemBuilder: (context, index) {
                    final item = searchData![index];
                    return BoxList(
                      index: index + 1,
                      title: item['tipe_sepatu'],
                      material: item['bahan'],
                      totalSize: item['jml_size'].toString(),
                      totalVariant: item['jml_warna'].toString(),
                      weight: item['berat'].toString(),
                      price: item['harga'].toString(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
