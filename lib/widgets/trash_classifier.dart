import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class TrashClassifier extends StatefulWidget {
  @override
  State<TrashClassifier> createState() => _TrashClassifierState();
}

class _TrashClassifierState extends State<TrashClassifier> {
  XFile? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() => _image = picked);
      // TODO: AI 분류 및 결과 표시
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _image == null
            ? Text('사진을 촬영해 주세요')
            : Image.file(File(_image!.path)),
        ElevatedButton(
          onPressed: _pickImage,
          child: Text('사진 촬영'),
        ),
        // TODO: 분류 결과 및 분리수거 안내 표시
      ],
    );
  }
} 