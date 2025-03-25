import 'package:flutter/material.dart';
import 'package:sportition_center/models/join/join_dto.dart';
import 'package:sportition_center/services/trainer/user_search_service.dart';
import 'package:sportition_center/shared/styles/app_colors.dart';

class LoginInfoStep extends StatefulWidget {
  final ValueChanged<int> onPageIndexChanged;
  final JoinDTO joinDTO;

  const LoginInfoStep({
    super.key,
    required this.onPageIndexChanged,
    required this.joinDTO,
  });

  @override
  _LoginInfoStepState createState() => _LoginInfoStepState();
}

class _LoginInfoStepState extends State<LoginInfoStep> {
  String? errorMessage;
  String? email;
  String? password;

  Future<void> settingLoginInfo() async {
    // Email 확인
    if (email == null || email!.isEmpty) {
      setState(() {
        errorMessage = '이메일을 입력해주세요.';
      });
      return;
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email!)) {
      setState(() {
        errorMessage = '유효한 이메일 형식을 입력해주세요.';
      });
      return;
    } else {
      // 이메일 중복확인
      if (await UserSearchService().hasUser(type: 'email', email: email!)) {
        setState(() {
          errorMessage = '이미 가입된 이메일입니다.';
        });
        return;
      } else {
        widget.joinDTO.email = email;
      }
    }
    // Password 확인
    if (password == null || password!.isEmpty) {
      setState(() {
        errorMessage = '비밀번호를 입력해주세요.';
      });
      return;
    } else if (password!.length < 6) {
      setState(() {
        errorMessage = '비밀번호는 6자 이상이어야 합니다.';
      });
      return;
    } else {
      widget.joinDTO.password = password;
    }
    widget.onPageIndexChanged(3);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Column(
          children: [
            Text(
              '로그인 정보 설정',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '회원가입 하려는 사용자의 로그인 정보를 입력해주세요.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
        /* 이메일 입력 */
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              TextField(
                onChanged: (value) {
                  email = value;
                },
                decoration: const InputDecoration(
                  labelText: '이메일',
                  hintText: '이메일을 입력해주세요.',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  password = value;
                },
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '비밀번호',
                  hintText: '비밀번호를 입력해주세요.',
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        /* 다음 버튼 */
        IconButton(
          onPressed: () {
            settingLoginInfo();
          },
          icon: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.mainRedColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Icon(Icons.arrow_forward, color: Colors.white)),
        ),
        if (errorMessage != null)
          Text(
            errorMessage!,
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
      ],
    );
  }
}
