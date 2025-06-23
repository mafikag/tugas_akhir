import 'package:flutter/material.dart';
import 'package:spk_app/page/Authentication/utils/CustomTextField.dart';
import 'package:spk_app/page/Authentication/utils/LoginControlButton.dart';

class Login extends StatefulWidget {
  final VoidCallback onSignUp;
  final VoidCallback onForgotPassword;
  const Login({
    super.key,
    required this.onSignUp,
    required this.onForgotPassword,
  });

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
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
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      label: 'Email',
                      controller: _emailController,
                    ),
                    CustomTextField(
                      label: 'Password',
                      isPassword: true,
                      controller: _passwordController,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ForgetPassTextButton(
                          onForgotPassword: widget.onForgotPassword,
                        ),
                        LoginButton(
                          emailController: _emailController,
                          passwordController: _passwordController,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account? ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SignUpTextButton(onSignUp: widget.onSignUp),
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
