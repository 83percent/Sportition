import 'package:flutter/material.dart';
import 'package:sportition_center/models/center/center_regist_dto.dart';
import 'package:sportition_center/models/join/join_dto.dart';
import 'package:sportition_center/services/center/center_regist_service.dart';
import 'package:sportition_center/services/trainer/trainer_register_service.dart';
import 'package:sportition_center/shared/styles/app_colors.dart';

class JoinResultStep extends StatefulWidget {
  final JoinDTO joinDTO;

  const JoinResultStep({
    super.key,
    required this.joinDTO,
  });

  @override
  _JoinResultStepState createState() => _JoinResultStepState();
}

class _JoinResultStepState extends State<JoinResultStep> {
  late Future<bool> _joinResult;
  late Future<void> _initJoinResultFuture;

  Future<void> _initJoinResult() async {
    try {
      /*
        Step 1: 신규 센터 등록일 경우, 센터 등록
      */
      if (widget.joinDTO.centerName != null ||
          widget.joinDTO.centerName! != '') {
        CenterRegistDTO centerRegistDTO =
            CenterRegistDTO(centerName: widget.joinDTO.centerName!);
        String registCenterUID =
            await CenterRegistService().registCenter(centerRegistDTO);

        widget.joinDTO.centerUID = registCenterUID;
      }

      /*
        Step 2: 사용자 등록
      */
      await TrainerRegisterService().registerTrainer(widget.joinDTO);

      setState(() {
        _joinResult = Future.value(true);
      });
    } catch (e) {
      setState(() {
        _joinResult = Future.value(false);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initJoinResultFuture = _initJoinResult();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initJoinResultFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.mainRedColor,
            ),
          );
        } else {
          return FutureBuilder<bool>(
            future: _joinResult,
            builder: (context, resultSnapshot) {
              if (resultSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.mainRedColor,
                  ),
                );
              } else if (resultSnapshot.data == true) {
                return Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    children: [
                      const Text(
                        '회원가입이 완료되었습니다.',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.mainRedColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login', (route) => false);
                        },
                        icon: const Icon(Icons.lock),
                      )
                    ],
                  ),
                );
              } else {
                return Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    children: [
                      const Text(
                        '회원가입에 실패하였습니다. 잠시 후 다시 시도 해주세요.',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login', (route) => false);
                        },
                        icon: const Icon(Icons.lock),
                      )
                    ],
                  ),
                );
              }
            },
          );
        }
      },
    );
  }
}
