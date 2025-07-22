import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import '../models/plogging_record.dart';
import '../models/trash_record.dart';
import '../models/user.dart';

class FirebaseService {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;

  // 현재 사용자 가져오기
  User? get currentUser => _auth.currentUser;

  // 인증 상태 변경 스트림
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 이메일/비밀번호로 로그인
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // 이메일/비밀번호로 회원가입
  Future<UserCredential> createUserWithEmailAndPassword(String email, String password, String name) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
      // 사용자 프로필 업데이트
      await userCredential.user?.updateDisplayName(name);
      
      // Firestore에 사용자 정보 저장
      final user = PloggingUser(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        profileImageUrl: '',
        totalDistance: 0,
        totalTrash: 0,
        badges: [],
      );
      await saveUser(user);
      
      return userCredential;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // 비밀번호 재설정 이메일 보내기
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // 인증 오류 처리
  String _handleAuthError(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return '해당 이메일로 등록된 사용자가 없습니다.';
        case 'wrong-password':
          return '비밀번호가 올바르지 않습니다.';
        case 'email-already-in-use':
          return '이미 사용 중인 이메일입니다.';
        case 'weak-password':
          return '비밀번호가 너무 약합니다.';
        case 'invalid-email':
          return '유효하지 않은 이메일 형식입니다.';
        case 'too-many-requests':
          return '너무 많은 로그인 시도가 있었습니다. 잠시 후 다시 시도해주세요.';
        default:
          return '로그인 중 오류가 발생했습니다: ${e.message}';
      }
    }
    return '알 수 없는 오류가 발생했습니다.';
  }

  // 플로깅 기록 저장
  Future<void> savePloggingRecord(PloggingRecord record) async {
    await _firestore.collection('plogging_records').doc(record.id).set(record.toMap());
  }

  // 쓰레기 기록 저장
  Future<void> saveTrashRecord(TrashRecord record) async {
    await _firestore.collection('trash_records').doc(record.id).set(record.toMap());
  }

  // 사용자 정보 저장
  Future<void> saveUser(PloggingUser user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap());
  }

  // 이미지 업로드
  Future<String> uploadImage(String path, String fileName) async {
    final ref = _storage.ref().child('trash_images/$fileName');
    final uploadTask = await ref.putFile(File(path));
    return await uploadTask.ref.getDownloadURL();
  }
}