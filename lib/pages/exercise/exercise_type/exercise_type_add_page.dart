import 'package:flutter/material.dart';

class ExerciseTypeAddPage extends StatefulWidget {
  @override
  _ExerciseTypeAddPageState createState() => _ExerciseTypeAddPageState();
}

class _ExerciseTypeAddPageState extends State<ExerciseTypeAddPage> {
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
                    '운동 추가',
                    style: TextStyle(
                      fontFamily: 'NotoSansKR',
                      color: Colors.black,
                      fontSize: 34,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight, // 가로 기준 오른쪽에 위치
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: const Center(
        child: Text('운동 추가 페이지'),
      ),
    );
  }
}
