import 'package:flutter/material.dart';
import 'package:sportition_center/shared/styles/app_colors.dart';

class ExerciseCountTab extends StatelessWidget {
  final String? exerciseName;
  final String? exerciseValue;
  final double weight;
  final int reps;
  final Function(int) onRepsChanged;
  final VoidCallback onSelectExercise;
  final VoidCallback onSelectWeight;
  final VoidCallback onSave;

  const ExerciseCountTab({
    Key? key,
    required this.exerciseName,
    required this.exerciseValue,
    required this.weight,
    required this.reps,
    required this.onRepsChanged,
    required this.onSelectExercise,
    required this.onSelectWeight,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (exerciseValue == null || exerciseValue!.isEmpty) {
      return Center(
        child: GestureDetector(
          onTap: onSelectExercise,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const Text('운동을 선택해주세요.'),
          ),
        ),
      );
    }

    if (weight == 0) {
      return Center(
        child: GestureDetector(
          onTap: onSelectWeight,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const Text('무게를 설정해주세요.'),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              '$exerciseName',
              style: const TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 32.0),
          const Padding(
            padding: EdgeInsets.only(
              left: 16.0,
            ),
            child: Text('횟수 설정 (회)'),
          ),
          const SizedBox(height: 32.0),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 110,
                height: MediaQuery.of(context).size.width - 110,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                      begin: 0, end: (reps > 15 ? 15 : reps) / 15),
                  duration: const Duration(milliseconds: 200),
                  builder: (context, value, child) {
                    return CircularProgressIndicator(
                      value: value,
                      strokeWidth: 30,
                      backgroundColor: AppColors.borderGray010Color,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.mainRedColor,
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    padding: const EdgeInsets.all(20),
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (reps > 0) {
                        onRepsChanged(reps - 1);
                      }
                    },
                  ),
                  SizedBox(
                    width: 60,
                    child: Center(
                      child: Text(
                        '$reps',
                        style: const TextStyle(
                          fontSize: 34.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    padding: const EdgeInsets.all(20),
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      onRepsChanged(reps + 1);
                    },
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 100),
            opacity: reps > 0 ? 1.0 : 0.4,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              decoration: const BoxDecoration(
                color: AppColors.mainRedColor,
              ),
              padding: EdgeInsets.symmetric(vertical: reps > 0 ? 9.0 : 0.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.mainRedColor,
                  minimumSize: const Size(double.infinity, 40),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                onPressed: reps > 0
                    ? onSave // 저장 버튼 클릭 시 동작
                    : null,
                child: const Text(
                  '저장',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'NotoSans',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
