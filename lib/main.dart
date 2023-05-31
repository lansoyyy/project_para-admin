import 'package:flutter/material.dart';
import 'package:project_para_admin/screens/home_screen.dart';
import 'package:project_para_admin/screens/splashtohome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashToHomeScreen(),
    );
  }
}
