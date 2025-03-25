import 'package:flutter/material.dart';
import 'package:sportition_center/models/login/login_request_dto.dart';
import 'package:sportition_center/shared/styles/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart'; // AutoSizeText 패키지 추가
import 'package:sportition_center/services/login/login_service.dart'; // LoginService 패키지 추가

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginRequestDTO _loginRequestDTO = LoginRequestDTO();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _login() async {
    final loginService = LoginService();
    try {
      bool success = await loginService.login(context, _loginRequestDTO);
      if (success) {
        Navigator.pushReplacementNamed(context, '/home'); // 로그인 성공 시 홈 화면으로 이동
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())), // 에러 메시지 표시
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    onChanged: (value) => _loginRequestDTO.email = value,
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
                    onChanged: (value) => _loginRequestDTO.password = value,
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
                  '로그인',
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
