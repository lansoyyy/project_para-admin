import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_para_admin/screens/splashtohome_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'project-phara',
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
