import 'package:flutter/material.dart';
import 'package:sportition_center/services/login/login_service.dart';
import 'package:sportition_center/shared/styles/app_colors.dart';

class LoadPage extends StatefulWidget {
  const LoadPage({super.key});

  @override
  _LoadPageState createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    /* Widget Build 후에 실행될 Method 등록 */
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 0), () {
        setState(() {
          _opacity = 1.0;
        });
      });
      Future.delayed(const Duration(seconds: 2), () {
        afterBuild();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(seconds: 1),
          child: const Text(
            'SPORTITION',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 26,
              color: AppColors.mainRedColor,
            ),
          ),
        ),
      ),
    );
  }

  /* Widget Build 후에 실행됨 */
  void afterBuild() {
    // 로그인 확인
    LoginService().isLogin().then((isLogin) {
      if (isLogin) {
        // 메인 페이지로 이동
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // 로그인 페이지로 이동
        Navigator.pushReplacementNamed(context, '/login');
      }
    }).catchError((e) {
      // 로그인 과정에서 Error가 발생하는 경우 로그인 화면으로 이동한다.
      Navigator.pushReplacementNamed(context, '/login');
    });
  }
}
