import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_para_admin/screens/splashtohome_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDuwDmgZ2lA2ze9cmI-xfzXsmyu7FTpKNA",
          authDomain: "pasada-e0b64.firebaseapp.com",
          projectId: "pasada-e0b64",
          storageBucket: "pasada-e0b64.appspot.com",
          messagingSenderId: "976579912832",
          appId: "1:976579912832:web:afa0099ac194b45b10f265"));
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
