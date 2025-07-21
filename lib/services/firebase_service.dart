import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/plogging_record.dart';
import '../models/trash_record.dart';
import '../models/user.dart';

class FirebaseService {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  // 플로깅 기록 저장
  Future<void> savePloggingRecord(PloggingRecord record) async {
    await _firestore.collection('plogging_records').doc(record.id).set(record.toMap());
  }

  // 쓰레기 기록 저장
  Future<void> saveTrashRecord(TrashRecord record) async {
    await _firestore.collection('trash_records').doc(record.id).set(record.toMap());
  }

  // 사용자 정보 저장
  Future<void> saveUser(FloggingUser user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap());
  }

  // 이미지 업로드
  Future<String> uploadImage(String path, String fileName) async {
    final ref = _storage.ref().child('trash_images/$fileName');
    final uploadTask = await ref.putFile(File(path));
    return await uploadTask.ref.getDownloadURL();
  }
} 