import 'package:flutter/material.dart';
import 'package:sportition_center/shared/styles/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart'; // AutoSizeText 패키지 추가
import 'package:sportition_center/services/login_service.dart'; // LoginService 패키지 추가

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    await LoginService.login(
      context,
      _emailController.text,
      _passwordController.text,
      _showAlert,
    );
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: const AutoSizeText(
                'SPORTITION',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 52,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mainRedColor,
                  height: 1,
                ),
                maxLines: 1, // 최대 줄 수를 1로 설정
              ),
            ),
            const Text(
              'Sport Networking',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 0, 0, 0)),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: 300,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.borderGray100Color,
                    width: 2.0,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '아이디',
                    style: TextStyle(
                        fontFamily: 'Notosans',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0x99000000)),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'example@xxx.xxx',
                      hintStyle: TextStyle(
                        fontFamily: 'Notosans',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0x77000000),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 300,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.borderGray100Color,
                    width: 2.0,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '비밀번호',
                    style: TextStyle(
                      fontFamily: 'Notosans',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0x99000000),
                    ),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true, // 비밀번호 입력 시 텍스트를 숨기는 속성 추가
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '********',
                      hintStyle: TextStyle(
                        fontFamily: 'Notosans',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0x77000000),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 350,
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: TextButton(
                onPressed: _login,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(AppColors.mainRedColor),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: const Text(
                  'LOGIN',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/join');
                  },
                  child: const Text(
                    '회원가입',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.baseBlack,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
