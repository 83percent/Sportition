import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sportition_center/models/login/login_request_dto.dart';
import 'package:sportition_center/providers/auth_provider.dart'
    as sportition_auth;

class LoginService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger('LoginService');

  // Singleton
  static final LoginService _loginService = LoginService._internal();
  LoginService._internal();
  factory LoginService() {
    return _loginService;
  }

  Future<bool> login(BuildContext context, LoginRequestDTO requestDTO) async {
    _validateEmail(requestDTO.email);
    _validatePassword(requestDTO.password);

    try {
      final authProvider =
          Provider.of<sportition_auth.AuthProvider>(context, listen: false);

      // Step 1. 사용자 정보 가져오기
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: requestDTO.email!, password: requestDTO.password!);

      // Step 2. Trainer 정보 가져오기
      DocumentSnapshot userDoc = await _firestore
          .collection('trainers')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('사용자 정보를 찾을 수 없습니다.');
      }

      // Step 3. Provider에 사용자 정보 저장
      authProvider.setUser(userCredential.user!.uid,
          userDoc['name']); // context 대신 authProvider 사용

      // Step 4. SharedPreferences에 사용자 정보 저장
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('trainerUID', userCredential.user!.uid);
      await prefs.setString('centerUID', userDoc['centerUID']);

      return true;
    } on FirebaseAuthException catch (e) {
      _logger.info(e);
      _logger.severe('Failed to sign in: $e');
      throw Exception('로그인에 실패했습니다. 이메일과 비밀번호를 확인해주세요.');
    } on Exception catch (e) {
      print(e);
      _logger.severe('Failed to sign in: $e');
      throw Exception('로그인에 실패했습니다. 이메일과 비밀번호를 확인해주세요.');
    }
  }

  void _validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      throw Exception('이메일을 입력해주세요.');
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      throw Exception('이메일 형식을 확인해주세요.');
    }
  }

  void _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      throw Exception('비밀번호를 입력해주세요.');
    }

    final passwordRegex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,20}$');
    if (!passwordRegex.hasMatch(password)) {
      throw Exception('비밀번호 형식을 확인해주세요.');
    }
  }

  void _saveUserInfo(String tarinerUID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('trainerUID', tarinerUID);
  }

  Future<bool> isLogin() async {
    _logger.log(Level.ALL,
        '====================== LOGIN SERVICE ======================');

    // SharedPreferences 에서 저장되어q있는 clientUID를 가져온다.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? trainerUID = prefs.getString('trainerUID');

    // Firebase Authentication의 현재 사용자를 가져온다.
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (trainerUID != null &&
        currentUser != null &&
        currentUser.uid == trainerUID) {
      return true;
    } else {
      return false;
    }
  }
}
