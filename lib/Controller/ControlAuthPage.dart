import 'package:flutter/material.dart';
import 'package:spk_app/page/Authentication/views/ForgetPassPage.dart';
import 'package:spk_app/page/Authentication/views/Login.dart';
import 'package:spk_app/page/Authentication/views/SingUp_Page.dart';

// ignore: must_be_immutable
class ControlAuthPage extends StatefulWidget {
  int selectedIndex;
  ControlAuthPage({super.key, required this.selectedIndex});

  @override
  State<ControlAuthPage> createState() => _ControlAuthPageState();
}

class _ControlAuthPageState extends State<ControlAuthPage> {
  late int selectedIndex;
  late int previousIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
    previousIndex = selectedIndex;
  }

  void _setIndex(int index) {
    setState(() {
      previousIndex = selectedIndex;
      selectedIndex = index;
    });
  }

  Widget _buildFormContent() {
    switch (selectedIndex) {
      case 1:
        return SignUpPage(
          onBackToLogin: () => _setIndex(0),
          key: ValueKey("signup"),
        );
      case 2:
        return ForgetPassPage(
          onBackToLogin: () => _setIndex(0),
          key: ValueKey("forgot"),
        );
      default:
        return Login(
          onSignUp: () => _setIndex(1),
          onForgotPassword: () => _setIndex(2),
          key: ValueKey("login"),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isForward = selectedIndex > previousIndex;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Bg.png'),
            fit: BoxFit.cover,
            alignment: Alignment.bottomLeft,
            repeat: ImageRepeat.repeatX,
          ),
        ),
        child: Column(
          children: [
            // // Bagian atas: background dengan logo
            Expanded(flex: 2, child: SizedBox(height: 400)),
            // Bagian bawah: form dinamis dengan transisi halus
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 239, 255, 251),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) {
                    final offsetAnimation = Tween<Offset>(
                      begin:
                          isForward
                              ? const Offset(1.0, 0.0)
                              : const Offset(-1.0, 0.0),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOut,
                      ),
                    );

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                  child: _buildFormContent(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
