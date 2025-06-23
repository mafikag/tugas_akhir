import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spk_app/page/Authentication/utils/CustomTextField.dart';
import 'package:spk_app/page/Authentication/utils/SingUpControlButton.dart';

class ForgetPassPage extends StatefulWidget {
  final VoidCallback onBackToLogin;
  const ForgetPassPage({super.key, required this.onBackToLogin});

  @override
  State<ForgetPassPage> createState() => _State();
}

class _State extends State<ForgetPassPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  Future<void> onClicked() async {
    final email = _emailController.text.trim();

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Jika berhasil kirim email
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link reset password telah dikirim.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
      // Kembali ke halaman login
      widget.onBackToLogin();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email tidak terdaftar'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Format email tidak valid'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: ${e.message}'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        color: const Color.fromARGB(255, 239, 255, 251),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Reset Password',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontFamily: 'Poppins',
                          ),
                        ),
                        // const SizedBox(height: 10),
                        // Add your sign-up form fields here
                        CustomTextField(
                          label: 'Email',
                          controller: _emailController,
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 500,
                          child: ElevatedButton(
                            onPressed: () {
                              onClicked();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                78,
                                171,
                                51,
                              ),
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              shadowColor: Colors.black,
                              elevation: 0,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                // horizontal: 16,
                              ),
                              child: Text(
                                'Sent Email',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Back to',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Back(onBackToLogin: widget.onBackToLogin),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
