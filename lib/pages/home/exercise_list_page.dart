import 'package:flutter/material.dart';
import 'package:sportition_center/models/exercise/exercise_type_dto.dart';
import 'package:sportition_center/pages/exercise/exercise_list_widget.dart';
import 'package:sportition_center/services/exercise/exercise_type_service.dart';

class ExerciseListPage extends StatefulWidget {
  const ExerciseListPage({Key? key}) : super(key: key);

  @override
  _ExerciseListPageState createState() => _ExerciseListPageState();
}

class _ExerciseListPageState extends State<ExerciseListPage> {
  late Future<List<ExerciseTypeDTO>> _exerciseTypeList;

  @override
  void initState() {
    super.initState();
    _exerciseTypeList = _getExerciseTypeList();
  }

  Future<List<ExerciseTypeDTO>> _getExerciseTypeList() async {
    return await ExerciseTypeService().getExerciseTypeList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _exerciseTypeList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
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
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // 버튼을 오른쪽에 위치
                    children: [
                      Container(
                        alignment: Alignment.centerLeft, // 가로 기준 왼쪽에 위치
                        child: const Text(
                          '운동 목록',
                          style: TextStyle(
                            fontFamily: 'NotoSansKR',
                            color: Colors.black,
                            fontSize: 34,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.add,
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
            body: ExerciseListWidget(),
          );
        } else {
          return Center(child: Text('No data'));
        }
      },
    );
  }
}
