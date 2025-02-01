import 'package:flutter/material.dart';

class UserInfoStep extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;

  const UserInfoStep({
    Key? key,
    required this.nameController,
    required this.phoneController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: '이름',
            contentPadding: EdgeInsets.only(
              top: -5,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          controller: phoneController,
          decoration: const InputDecoration(
            labelText: '연락처',
            contentPadding: EdgeInsets.only(
              top: -5,
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
