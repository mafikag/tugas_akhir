import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spk_app/Controller/firebase_options.dart';
import 'package:spk_app/Controller/UserControl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: UserControl(),
    );
  }
}
