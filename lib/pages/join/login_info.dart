import 'package:flutter/material.dart';

class LoginInfoStep extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const LoginInfoStep({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: '이메일',
            contentPadding: EdgeInsets.only(
              top: -5,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          controller: passwordController,
          decoration: const InputDecoration(
            labelText: '비밀번호',
            contentPadding: EdgeInsets.only(
              top: -5,
            ),
          ),
          obscureText: true,
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          controller: confirmPasswordController,
          decoration: const InputDecoration(
            labelText: '비밀번호 확인',
            contentPadding: EdgeInsets.only(
              top: -5,
            ),
          ),
          obscureText: true,
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
