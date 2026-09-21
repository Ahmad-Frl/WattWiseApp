import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wattwiseapp/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
  runApp(const WattWiseApp());
}

class WattWiseApp extends StatelessWidget {
  const WattWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WattWise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(), 
    );
  }
}