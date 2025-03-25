import 'package:flutter/material.dart';
import 'package:sportition_center/models/join/join_dto.dart';
import 'package:sportition_center/services/center/center_search_service.dart';
import 'package:sportition_center/shared/styles/app_colors.dart';

class CenterInfoStep extends StatefulWidget {
  final ValueChanged<int> onPageIndexChanged;
  final JoinDTO joinDTO;

  const CenterInfoStep({
    super.key,
    required this.onPageIndexChanged,
    required this.joinDTO,
  });

  @override
  _CenterInfoStepState createState() => _CenterInfoStepState();
}

class _CenterInfoStepState extends State<CenterInfoStep> {
  bool? isExistCenter;
  String centerName = '';
  String centerUID = '';
  String? errorMessage;

  Future<void> settingCenter() async {
    try {
      if (isExistCenter == null) {
        setState(() {
          errorMessage = '센터 설정을 선택해주세요.';
        });
      } else if (isExistCenter == true) {
        if (centerUID.isEmpty) {
          setState(() {
            errorMessage = '센터 코드를 입력해주세요.';
          });
        } else {
          // 센터 코드로 센터 정보 조회
          if (await CenterSearchService()
              .hasCenter(type: 'uid', centerUID: centerUID)) {
            widget.joinDTO.centerUID = centerUID;
            widget.joinDTO.centerName = '';
            widget.onPageIndexChanged(2);
          } else {
            setState(() {
              errorMessage = '해당 센터가 존재하지 않습니다.';
            });
          }
        }
      } else {
        if (centerName.isEmpty) {
          setState(() {
            errorMessage = '센터명을 입력해주세요.';
          });
        } else {
          // 센터명으로 센터 정보 조회
          if (await CenterSearchService()
              .hasCenter(type: 'name', centerName: centerName)) {
            setState(() {
              errorMessage = '이미 존재하는 센터명입니다.';
            });
          } else {
            // 센터 등록
            widget.joinDTO.centerUID = '';
            widget.joinDTO.centerName = centerName;
            widget.onPageIndexChanged(2);
          }
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = '센터 설정 중 오류가 발생했습니다.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const Column(
            children: [
              Text(
                '센터 설정',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '회원가입 하려는 사용자의 소속 센터를 입력해주세요.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
          /* 기존 센터 등록 */
          Column(
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    isExistCenter = true;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isExistCenter == true
                        ? AppColors.mainRedColor
                        : Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: isExistCenter == true
                          ? Colors.transparent
                          : Colors.black,
                      width: 1,
                    ),
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: Text(
                    '이미 SPORTITION에 가입된 센터입니다.',
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          isExistCenter == true ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              /* 센터 UID 입력 */
              if (isExistCenter == true)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                    onChanged: (value) {
                      centerUID = value;
                    },
                    decoration: const InputDecoration(
                      labelText: '센터 코드 입력',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
            ],
          ),
          /* 센터 신규 가입 */
          Column(
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    isExistCenter = false;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isExistCenter == false
                        ? AppColors.mainRedColor
                        : Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: isExistCenter == false
                          ? Colors.transparent
                          : Colors.black,
                      width: 1,
                    ),
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: Text(
                    '신규 가입 센터입니다.',
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          isExistCenter == false ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              /* 센터명 입력 */
              if (isExistCenter == false)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                    onChanged: (value) {
                      centerName = value;
                    },
                    decoration: const InputDecoration(
                      labelText: '센터명 입력',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
            ],
          ),
          /* 다음 버튼 */
          IconButton(
            onPressed: () {
              settingCenter();
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
      ),
    );
  }
}
