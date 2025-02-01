import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sportition_center/providers/auth_provider.dart'
    as sportition_auth;

class LoginService {
  static final Logger _logger = Logger('LoginService');

  static Future<void> login(
    BuildContext context,
    String email,
    String password,
    Function(String) showAlert,
  ) async {
    if (email.isEmpty) {
      showAlert('아이디를 입력해주세요.');
      return;
    } else if (!_isValidEmail(email)) {
      showAlert('아이디 형식을 확인해주세요.');
      return;
    } else if (password.isEmpty) {
      showAlert('비밀번호를 입력해주세요.');
      return;
    } else if (!_isValidPassword(password)) {
      showAlert('비밀번호 형식을 확인해주세요.');
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      Map<String, dynamic> data = {};
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _logger.info('User signed in : ${userCredential}');

      String userType = 'client';

      // Firestore에서 사용자 데이터 가져오기
      DocumentSnapshot clientDoc = await FirebaseFirestore.instance
          .collection('clients')
          .doc(userCredential.user!.uid)
          .get();

      if (!clientDoc.exists) {
        // Step1. Client 정보가 없으면 Trainer 정보를 가져온다.
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('trainers')
            .doc(userCredential.user!.uid)
            .get();

        if (!userDoc.exists) {
          Navigator.of(context).pop(); // 로딩 창 제거
          showAlert('사용자 정보를 찾을 수 없습니다.');
          return;
        } else {
          userType = 'trainer';
          data = userDoc.data() as Map<String, dynamic>;
        }
      } else {
        userType = 'client';
        data = clientDoc.data() as Map<String, dynamic>;
      }

      // Provider에 사용자 정보 저장
      Provider.of<sportition_auth.AuthProvider>(context, listen: false)
          .setUser(userCredential.user!.uid, data['name']);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userType', userType);
      await prefs.setString('uid', userCredential.user!.uid);
      await prefs.setString('userEmail', email);
      await prefs.setString('name', data['name']);
      await prefs.setString('centerUID', data['center']);

      Navigator.of(context).pop(); // 로딩 창 제거
      if (userType == 'trainer') {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/clients/home');
      }
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop(); // 로딩 창 제거
      showAlert('로그인 정보를 확인해주세요.');
    }
  }

  static void autoLogin(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    String? userType = prefs.getString('userType');

    if (uid != null && userType != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection(userType == 'trainer' ? 'trainers' : 'clients')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        Provider.of<sportition_auth.AuthProvider>(context, listen: false)
            .setUser(uid, userData['name']);

        Navigator.pushReplacementNamed(
            context, userType == 'trainer' ? '/home' : '/clients/home');
      } else {
        if (Navigator.canPop(context)) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    } else {
      if (Navigator.canPop(context)) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  static bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  static bool _isValidPassword(String password) {
    final passwordRegex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,20}$');
    return passwordRegex.hasMatch(password);
  }
}
