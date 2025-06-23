import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:spk_app/page/Home/utils/boxKategori.dart';
import 'package:spk_app/page/Home/utils/dialogLogOut.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String name = 'User';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: user.email)
              .get();

      if (doc.docs.isNotEmpty) {
        final data = doc.docs.first.data();
        setState(() {
          name = data['username'] ?? 'User';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
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
        )
        : Container(
          color: const Color.fromARGB(255, 239, 255, 251),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isLoading ? 'Hello, ...' : 'Hello, $name',
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 39, 39, 39),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const Text(
                                'Welcome to DOPICKS',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(155, 39, 39, 39),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return dialogLogOut();
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                80,
                                216,
                                144,
                              ),
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.logout_rounded,
                                  size: 30,
                                  color: Color.fromARGB(255, 39, 39, 39),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Collection',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 39, 39, 39),
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: [
                            BoxKategori(
                              title: 'Compass',
                              imageUrl: 'assets/images/Compass.png',
                            ),
                            BoxKategori(
                              title: 'Kanky',
                              imageUrl: 'assets/images/Kanky.png',
                            ),
                            BoxKategori(
                              title: 'Patrobas',
                              imageUrl: 'assets/images/Patrobass.png',
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
  }
}
