import 'package:flutter/material.dart';
import 'package:sportition_center/models/join/join_dto.dart';
import 'package:sportition_center/shared/styles/app_colors.dart';

class UserInfoStep extends StatefulWidget {
  final ValueChanged<int> onPageIndexChanged;
  final JoinDTO joinDTO;

  const UserInfoStep({
    Key? key,
    required this.onPageIndexChanged,
    required this.joinDTO,
  }) : super(key: key);

  @override
  _UserInfoStepState createState() => _UserInfoStepState();
}

class _UserInfoStepState extends State<UserInfoStep> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Column(
          children: [
            Text(
              '사용자 정보 설정',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '회원가입 하려는 사용자의 정보를 입력해주세요.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
        /* 이름 입력 */
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              TextField(
                onChanged: (value) {
                  widget.joinDTO.name = value;
                },
                decoration: const InputDecoration(
                  labelText: '이름',
                  hintText: '이름을 입력해주세요.',
                ),
              ),
              /* 완료 버튼 */
              IconButton(
                onPressed: () {
                  widget.onPageIndexChanged(99);
                },
                icon: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.mainRedColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Icon(Icons.check, color: Colors.white)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
