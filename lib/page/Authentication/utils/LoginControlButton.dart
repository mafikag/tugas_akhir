import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:spk_app/Controller/ControlContentPage.dart';

// ===============================
// LOGIN BUTTON
// ===============================
class LoginButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginButton({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  Future<void> onClicked(BuildContext context) async {
    try {
      // Login ke Firebase
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Tampilkan loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => Center(
              child: Lottie.asset(
                'assets/animation/Loading.json',
                width: 500,
                height: 500,
                repeat: true,
                reverse: false,
                animate: true,
              ),
            ),
      );

      // Delay agar loading terlihat (opsional)
      await Future.delayed(const Duration(seconds: 1));

      // Tutup dialog loading
      Navigator.of(context).pop();

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder:
              (context, animation, secondaryAnimation) =>
                  Controlcontentpage(selectedIndex: 0), // Ganti sesuai tujuan
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final beginScale = 1.5;
            final endScale = 1.0;

            final fadeIn = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );

            return FadeTransition(
              opacity: fadeIn,
              child: ScaleTransition(
                scale: Tween<double>(
                  begin: beginScale,
                  end: endScale,
                ).animate(fadeIn),
                child: child,
              ),
            );
          },
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMsg = '';
      if (e.code == 'user-not-found') {
        errorMsg = 'Akun tidak ditemukan';
      } else if (e.code == 'wrong-password') {
        errorMsg = 'Password salah';
      } else if (e.code == 'invalid-email') {
        errorMsg = 'Format email tidak valid';
      } else {
        errorMsg = 'Terjadi kesalahan: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => onClicked(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3BBB2E),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 3,
        ),
        child: const Text(
          'Login',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// ===============================
// FORGET PASSWORD BUTTON
// ===============================
class ForgetPassTextButton extends StatelessWidget {
  final VoidCallback onForgotPassword;
  const ForgetPassTextButton({super.key, required this.onForgotPassword});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onForgotPassword,
      child: const Text(
        'Forgot Password?',
        style: TextStyle(
          color: Colors.blueAccent,
          fontSize: 14,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ===============================
// SIGN UP TEXT BUTTON
// ===============================
class SignUpTextButton extends StatelessWidget {
  final VoidCallback onSignUp;
  const SignUpTextButton({super.key, required this.onSignUp});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onSignUp,
      child: const Text(
        'Register',
        style: TextStyle(
          color: Colors.blueAccent,
          fontSize: 14,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
