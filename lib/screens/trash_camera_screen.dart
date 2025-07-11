import 'package:flutter/material.dart';
import '../widgets/trash_classifier.dart';

class TrashCameraScreen extends StatelessWidget {
  const TrashCameraScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('쓰레기 분류')),
      body: TrashClassifier(),
    );
  }
} 