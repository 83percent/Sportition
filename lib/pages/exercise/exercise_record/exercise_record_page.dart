import 'package:flutter/material.dart';
import 'package:sportition_center/models/exercise/exercise_model.dart';
import 'package:sportition_center/pages/exercise/exercise_type_tab.dart'; // 추가된 import
import 'package:sportition_center/pages/exercise/exercise_weight_tab.dart'; // 추가된 import
import 'package:sportition_center/pages/exercise/exercise_count_tab.dart'; // 추가된 import
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportition_center/services/record/record_service.dart'; // 추가된 import

class ExerciseRecordPage extends StatefulWidget {
  final String uid;
  final String name;

  const ExerciseRecordPage({
    Key? key,
    required this.uid,
    required this.name,
  }) : super(key: key);

  @override
  _ExerciseRecordPageState createState() => _ExerciseRecordPageState();
}

class _ExerciseRecordPageState extends State<ExerciseRecordPage>
    with SingleTickerProviderStateMixin {
  Exercise? selectedExercise;
  double weight = 0;
  int reps = 0;
  late TabController _tabController;
  late TextEditingController _weightController;
  final RecordService _recordService = RecordService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _weightController = TextEditingController(text: weight.toString());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _saveRecord() async {
    if (selectedExercise == null || weight < 0.5 || reps < 1) {
      _showAlertDialog('저장할 데이터가 없습니다.');
      return;
    }

    _showLoadingDialog();

    final prefs = await SharedPreferences.getInstance();
    final userUid = prefs.getString('uid') ?? '';

    try {
      await _recordService.save(
        uid: widget.uid,
        data: {
          'exerciseId': selectedExercise!.value,
          'exerciseName': selectedExercise!.name,
          'weight': weight,
          'count': reps,
        },
      );

      Navigator.of(context).pop(); // 로딩창 닫기
      _showAlertDialog('저장되었습니다.');
      setState(() {
        reps = 0; // 저장 성공 시 reps를 0으로 변경
      });
    } catch (e) {
      Navigator.of(context).pop(); // 로딩창 닫기
      _showAlertDialog('저장에 실패하였습니다.');
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        toolbarHeight: 80,
        title: Container(
          alignment: Alignment.centerLeft, // 가로 기준 왼쪽에 위치
          child: Text(
            '운동 - ${widget.name}',
            style: const TextStyle(
              fontFamily: 'NotoSansKR',
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '운동 설정'),
            Tab(text: '무게 설정'),
            Tab(text: '횟수 설정'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ExerciseTypeTab(
            onExerciseSelected: (exercise) {
              setState(() {
                selectedExercise = exercise;
                weight = 0; // 운동이 변경될 때 무게를 0으로 설정
                _weightController.text = '0'; // 도넛의 숫자도 0으로 업데이트
                reps = 0;
                _tabController.animateTo(1); // 무게 설정 탭으로 이동
              });
            },
          ),
          ExerciseWeightTab(
            exerciseName: selectedExercise?.name ?? '',
            exerciseValue: selectedExercise?.value ?? '',
            weight: weight,
            onWeightChanged: (newWeight) {
              setState(() {
                weight = newWeight;
              });
              _weightController.text = newWeight.toString();
            },
            onSelectExercise: () {
              _tabController.animateTo(0); // 운동 설정 탭으로 이동
            },
            weightController: _weightController,
          ),
          ExerciseCountTab(
            exerciseName: selectedExercise?.name ?? '',
            exerciseValue: selectedExercise?.value ?? '',
            weight: weight,
            reps: reps,
            onRepsChanged: (newReps) {
              setState(() {
                reps = newReps;
              });
            },
            onSelectExercise: () {
              _tabController.animateTo(0); // 운동 설정 탭으로 이동
            },
            onSelectWeight: () {
              _tabController.animateTo(1); // 무게 설정 탭으로 이동
            },
            onSave: _saveRecord, // 저장 버튼 클릭 시 동작
          ),
        ],
      ),
    );
  }
}
