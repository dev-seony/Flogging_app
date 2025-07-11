import 'package:flutter/material.dart';
import '../widgets/jogging_map.dart';

class JoggingScreen extends StatelessWidget {
  const JoggingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('조깅 기록')),
      body: JoggingMap(),
    );
  }
} 