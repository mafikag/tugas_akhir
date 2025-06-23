import 'package:flutter/material.dart';
import 'package:spk_app/page/Authentication/utils/CustomTextField.dart';
import 'package:spk_app/page/Authentication/utils/SingUpControlButton.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback onBackToLogin;
  const SignUpPage({super.key, required this.onBackToLogin});

  @override
  State<SignUpPage> createState() => _State();
}

class _State extends State<SignUpPage> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: const Color.fromARGB(255, 239, 255, 251),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Add your sign-up form fields here
                    CustomTextField(
                      label: 'Username',
                      controller: _usernameController,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      label: 'Email',
                      controller: _emailController,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      label: 'Password',
                      isPassword: true,
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      label: 'Confirm password',
                      isPassword: true,
                      controller: _confirmPasswordController,
                    ),
                    const SizedBox(height: 10),
                    SignUpButton(
                      usernameController: _usernameController,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      onBackToLogin: widget.onBackToLogin,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Joined us before? ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
