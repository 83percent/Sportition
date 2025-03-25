import 'package:flutter/material.dart';
import 'package:sportition_center/models/join/join_dto.dart';
import 'package:sportition_center/pages/join/center_info_step.dart';
import 'package:sportition_center/pages/join/join_result_step.dart';
import 'package:sportition_center/pages/join/login_info_step.dart';
import 'package:sportition_center/pages/join/user_info_step.dart';
import 'package:sportition_center/services/join_service.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({super.key});

  @override
  _JoinPageState createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  late JoinService _joinService;
  late JoinDTO _joinDTO;

  int pageIndex = 1;

  @override
  void initState() {
    super.initState();
    _joinService = JoinService();
    _joinDTO = JoinDTO();
  }

  /* Step간 이동 */
  void _onPageIndexChanged(int newIndex) {
    setState(() {
      pageIndex = newIndex;
    });
  }

  Widget _getStepPage() {
    switch (pageIndex) {
      /* 센터 정보 입력 */
      case 1:
        return CenterInfoStep(
          onPageIndexChanged: _onPageIndexChanged,
          joinDTO: _joinDTO,
        );
      /* 로그인 정보 입력 */
      case 2:
        return LoginInfoStep(
          onPageIndexChanged: _onPageIndexChanged,
          joinDTO: _joinDTO,
        );
      /* 사용자 이름 입력 */

      case 3:
        return UserInfoStep(
          onPageIndexChanged: _onPageIndexChanged,
          joinDTO: _joinDTO,
        );
      /* 회원가입 완료 */
      case 99:
        return JoinResultStep(
          joinDTO: _joinDTO,
        );
      default:
        return CenterInfoStep(
          onPageIndexChanged: _onPageIndexChanged,
          joinDTO: _joinDTO,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          ' ',
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'NotosansKR',
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            _getStepPage(),
          ],
        ),
      ),
    );
  }
}
