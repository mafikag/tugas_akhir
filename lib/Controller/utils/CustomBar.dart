import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomBar extends StatelessWidget {
  final List<Widget> pages;
  CustomBar({super.key, required this.pages});

  final List<Tab> tabs = [
    const Tab(icon: Icon(Icons.home), text: "Home"),
    const Tab(icon: Icon(Icons.compare), text: "Compare"),
    const Tab(icon: Icon(Icons.info), text: "About"),
  ];

  @override
  Widget build(BuildContext context) {
    if (pages.length != tabs.length) {
      return Container(
        color: Color(0xFFEFFFFB),
        child: Center(
          child: Lottie.asset(
            'assets/animation/Loading.json',
            width: 300,
            height: 300,
            repeat: true,
            reverse: false,
            animate: true,
          ),
        ),
      ); // atau bisa juga return CircularProgressIndicator();
    }
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        body: TabBarView(children: pages),
        bottomNavigationBar: Material(
          color: const Color.fromARGB(255, 239, 255, 251),
          shadowColor: Colors.black,
          elevation: 5,
          child: TabBar(
            tabs: tabs,
            labelColor: const Color.fromARGB(255, 39, 39, 39),
            unselectedLabelColor: const Color.fromARGB(155, 39, 39, 39),
            // Ubah indikator ke bagian atas dengan custom decoration
            indicator: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color.fromARGB(255, 39, 39, 39),
                  width: 3,
                ),
              ),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
      ),
    );
  }
}
