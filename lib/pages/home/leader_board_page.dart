import 'package:flutter/material.dart';
import 'package:sportition_center/pages/leader_board/leader_board_list_page.dart';
import 'package:sportition_center/pages/leader_board/leader_board_select_gender_component.dart';
import 'package:sportition_center/pages/leader_board/leader_board_select_type_component.dart';

class LeaderBoardPage extends StatefulWidget {
  const LeaderBoardPage({Key? key}) : super(key: key);

  @override
  _LeaderBoardPageState createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends State<LeaderBoardPage> {
  String? selectedGender;
  String? selectedType;

  @override
  void initState() {
    super.initState();
  }

  void _onGenderSelected(String gender) {
    setState(() {
      selectedGender = gender;
    });
  }

  void _onTypeSelected(String type) {
    setState(() {
      selectedType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80), // 높이 조정
        child: AppBar(
          automaticallyImplyLeading: false, // 뒤로 가기 버튼 제거
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          toolbarHeight: 80,
          title: Padding(
            padding: const EdgeInsets.only(left: 16.0), // 왼쪽에 16의 패딩 설정
            child: Container(
              alignment: Alignment.centerLeft, // 가로 기준 왼쪽에 위치
              child: const Text(
                '리더보드',
                style: TextStyle(
                  fontFamily: 'NotoSansKR',
                  color: Colors.black,
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          centerTitle: false, // 제목을 중앙에 배치하지 않음
        ),
      ),
      body: Column(
        children: [
          /* 성별 선택 */
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
            ),
            child: LeaderBoardSelectGenderComponent(
              onGenderSelected: _onGenderSelected,
            ),
          ),
          /* 운동 유형 선택 */
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
            ),
            child: LeaderBoardSelectTypeComponent(
              onTypeSelected: _onTypeSelected,
            ),
          ),
          LeaderBoardListPage(
            gender: selectedGender ?? '',
            type: selectedType ?? '',
          )
        ],
      ),
    );
  }
}
