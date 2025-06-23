import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spk_app/Controller/utils/CustomBar.dart';
import 'package:spk_app/page/About/viewAbout.dart';
import 'package:spk_app/page/Home/views/AdminHome.dart';
import 'package:spk_app/page/Home/views/UserHome.dart';
import 'package:spk_app/page/Moora/view/viewCompare.dart';

// ignore: must_be_immutable
class Controlcontentpage extends StatefulWidget {
  int selectedIndex;
  Controlcontentpage({super.key, required this.selectedIndex});

  @override
  State<Controlcontentpage> createState() => _ControlcontentpageState();
}

class _ControlcontentpageState extends State<Controlcontentpage> {
  late int selectedIndex;
  late int previousIndex;

  final List<Widget> pages = [];

  Future<Widget> roleCheck() async {
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
          return Adminpage();
        }
      }
    }
    return Homepage();
  }

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
    previousIndex = selectedIndex;

    _initializePages();
  }

  Future<void> _initializePages() async {
    Widget homePage = await roleCheck();
    setState(() {
      pages.addAll([homePage, ViewCompare(), AboutPage()]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: IndexedStack(
        index: selectedIndex,
        key: ValueKey(selectedIndex), // for smooth transition
        children: pages,
      ),
      bottomNavigationBar: CustomBar(
        pages: pages,
        // Jika ingin aktif, tinggal aktifkan baris ini:
        // selectedIndex: selectedIndex,
        // onItemSelected: _setIndex,
      ),
    );
  }
}
