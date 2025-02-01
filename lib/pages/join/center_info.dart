import 'package:flutter/material.dart';

class CenterInfoStep extends StatelessWidget {
  final bool isExistingCenter;
  final TextEditingController centerUUIDController;
  final TextEditingController centerNameController;
  final ValueChanged<bool?> onChanged;
  final String userType; // 추가된 코드

  const CenterInfoStep({
    Key? key,
    required this.isExistingCenter,
    required this.centerUUIDController,
    required this.centerNameController,
    required this.onChanged,
    required this.userType, // 추가된 코드
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (userType == 'trainer') ...[
          RadioListTile<bool>(
            title: const Text('이미 SPORTITION을 사용하는 센터입니다.'),
            value: true,
            groupValue: isExistingCenter,
            onChanged: onChanged,
          ),
          RadioListTile<bool>(
            title: const Text('신규 등록 센터 입니다.'),
            value: false,
            groupValue: isExistingCenter,
            onChanged: onChanged,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
        if (isExistingCenter || userType == 'client')
          TextField(
            controller: centerUUIDController,
            decoration: const InputDecoration(
              labelText: '센터 코드 입력',
              contentPadding: EdgeInsets.only(
                top: -5,
              ),
            ),
          ),
        if (!isExistingCenter && userType == 'trainer')
          TextField(
            controller: centerNameController,
            decoration: const InputDecoration(
              labelText: '센터명 입력',
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
