import 'package:flutter/material.dart';

class CenterInviteListPage extends StatefulWidget {
  const CenterInviteListPage({super.key});

  @override
  State<CenterInviteListPage> createState() => _CenterInviteListPageState();
}

class _CenterInviteListPageState extends State<CenterInviteListPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: AppBar(
          automaticallyImplyLeading: false, // 뒤로 가기 버튼 제거
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          toolbarHeight: 80,
          title: Padding(
            padding: const EdgeInsets.only(left: 16.0), // 왼쪽에 16의 패딩 설정
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // 버튼을 오른쪽에 위치
              children: [
                Container(
                  alignment: Alignment.centerLeft, // 가로 기준 왼쪽에 위치
                  child: const Text(
                    '회원 등록 요청',
                    style: TextStyle(
                      fontFamily: 'NotoSansKR',
                      color: Colors.black,
                      fontSize: 34,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 30,
                  ),
                )
              ],
            ),
          ),
          centerTitle: false, // 제목을 중앙에 배치하지 않음
        ),
      ),
      body: Center(
        child: Text('센터 초대 리스트 페이지'),
      ),
    );
  }
}
