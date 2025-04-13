import 'package:flutter/material.dart';
import 'package:sportition_center/models/exercise/exercise_type_dto.dart';
import 'package:sportition_center/services/exercise/exercise_service.dart';
import 'package:sportition_center/services/exercise/exercise_type_service.dart';
import 'package:sportition_center/shared/styles/app_colors.dart';

class ExerciseTypeAddPage extends StatefulWidget {
  @override
  _ExerciseTypeAddPageState createState() => _ExerciseTypeAddPageState();
}

class _ExerciseTypeAddPageState extends State<ExerciseTypeAddPage> {
  String? exerciseName;
  String? selectedExerciseType;
  late Future<List<ExerciseTypeDTO>> _exerciseTypeList;

  @override
  void initState() {
    super.initState();
    _exerciseTypeList = ExerciseTypeService().getExerciseTypes();
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            /* 운동명 입력 */
            TextField(
              onChanged: (value) {
                exerciseName = value;
              },
              decoration: const InputDecoration(
                labelText: '운동명',
                labelStyle: TextStyle(
                  fontFamily: 'NotoSansKR',
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            /* 운동 부위 선택 */
            const SizedBox(height: 20),
            FutureBuilder<List<ExerciseTypeDTO>>(
              future: _exerciseTypeList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('운동 부위를 불러오는 중 오류가 발생했습니다.');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('운동 부위 데이터가 없습니다.');
                } else {
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: '운동 부위',
                      labelStyle: TextStyle(
                        fontFamily: 'NotoSansKR',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    items: snapshot.data!.map((type) {
                      return DropdownMenuItem<String>(
                        value: type.name,
                        child: Text(type.name ?? ''),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedExerciseType = value;
                      });
                    },
                  );
                }
              },
            ),
            /* 운동 추가 버튼 */
            const SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                if (exerciseName == null || selectedExerciseType == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('운동명과 운동 부위를 모두 입력해주세요.'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('운동 추가 중...'),
                    ),
                  );
                  try {
                    bool isDuplicate = await ExerciseService()
                        .isExerciseNameDuplicate(exerciseName!);
                    if (isDuplicate) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('이미 등록된 운동입니다.'),
                        ),
                      );
                      return;
                    }
                    await ExerciseService()
                        .addExercise(exerciseName!, selectedExerciseType!);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('운동이 성공적으로 추가되었습니다.'),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('오류가 발생하였습니다. 다시 시도해주세요.'),
                      ),
                    );
                  }
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.mainRedColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    '운동 추가',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
