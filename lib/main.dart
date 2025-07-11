import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'firebase_options.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(options: firebaseOptions);
  } else {
    await Firebase.initializeApp();
  }
  runApp(const FloggingApp());
}

class FloggingApp extends StatelessWidget {
  const FloggingApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flogging',
      theme: ThemeData(primarySwatch: Colors.green),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
