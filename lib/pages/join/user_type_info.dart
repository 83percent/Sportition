import 'package:flutter/material.dart';

class UserTypeInfoStep extends StatelessWidget {
  final String userType;
  final ValueChanged<String?> onChanged;

  const UserTypeInfoStep({
    Key? key,
    required this.userType,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<String>(
          title: const Text('회원'),
          value: 'client',
          groupValue: userType,
          onChanged: onChanged,
        ),
        RadioListTile<String>(
          title: const Text('트레이너'),
          value: 'trainer',
          groupValue: userType,
          onChanged: onChanged,
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
