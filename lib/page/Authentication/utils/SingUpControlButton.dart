import 'dart:ui' as ui;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class SignUpButton extends StatefulWidget {
  final TextEditingController usernameController; // Controller untuk username
  TextEditingController emailController; // Controller untuk email
  TextEditingController passwordController; // Controller untuk password
  TextEditingController
  confirmPasswordController; // Controller untuk konfirmasi password
  final VoidCallback onBackToLogin; // Callback untuk kembali ke halaman login
  SignUpButton({
    super.key,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onBackToLogin,
  });

  @override
  State<SignUpButton> createState() => _SignUpButtonState();
}

class _SignUpButtonState extends State<SignUpButton> {
  bool isHovered = false;

  @override
  void dispose() {
    super.dispose();
    widget.emailController.dispose();
    widget.passwordController.dispose();
    widget.confirmPasswordController.dispose();
  }

  Future addUser(String username, String email) async {
    // Jika username belum ada, tambahkan ke Firestore
    await FirebaseFirestore.instance.collection('users').add({
      'username': username,
      'email': email,
      'role': 'user',
      'createdAt': DateTime.now(),
    });
  }

  bool passwordconfirmed() {
    if (widget.passwordController.text ==
        widget.confirmPasswordController.text) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password tidak sesuai'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  Future<bool> usernameconfirmed(String username) async {
    final userCollection =
        await FirebaseFirestore.instance.collection('users').get();
    final userList = userCollection.docs;
    // Cek apakah username sudah ada di Firestore
    for (var user in userList) {
      if (user['username'] == username) {
        return false;
      }
    }
    return true;
  }

  Future onCicked() async {
    // Cek apakah username sudah ada di Firestore
    if (await usernameconfirmed(widget.usernameController.text.trim())) {
      if (passwordconfirmed()) {
        try {
          // Menambahkan user ke authentication
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: widget.emailController.text,
            password: widget.passwordController.text,
          );

          // Menambahkan user ke Firestore
          await addUser(
            widget.usernameController.text.trim(),
            widget.emailController.text.trim(),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Akun berhasil dibuat'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green,
            ),
          );

          // Kembali ke halaman login
          widget.onBackToLogin();
        } on FirebaseAuthException catch (e) {
          if (e.code == 'email-already-in-use') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Email sudah terdaftar'),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.red,
              ),
            );
          } else if (e.code == 'invalid-email') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Email tidak valid'),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Terjadi kesalahan ${e.message}'),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username sudah ada'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          onCicked();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const ui.Color.fromARGB(255, 78, 171, 51),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadowColor: Colors.black,
          elevation: 0,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Text(
            'Sign Up',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
// end class SignUpButton

// start class LoginTextButton
// ignore: must_be_immutable
class Back extends StatefulWidget {
  final VoidCallback onBackToLogin;
  const Back({super.key, required this.onBackToLogin});

  @override
  State<Back> createState() => _BackState();
}

class _BackState extends State<Back> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onBackToLogin,
      style: ButtonStyle(
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        minimumSize: WidgetStateProperty.all(ui.Size.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        shadowColor: WidgetStateProperty.all(Colors.transparent),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
      child: Text(
        'Login',
        style: TextStyle(
          fontSize: 14,
          color: Colors.blueAccent,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// end class LoginTextButton
