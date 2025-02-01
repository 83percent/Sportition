import 'package:flutter/material.dart';
import 'package:sportition_center/shared/styles/app_colors.dart';

class ExerciseWeightTab extends StatefulWidget {
  final String? exerciseName;
  final String? exerciseValue;
  final double weight;
  final Function(double) onWeightChanged;
  final VoidCallback onSelectExercise;
  final TextEditingController weightController;

  const ExerciseWeightTab({
    Key? key,
    required this.exerciseName,
    required this.exerciseValue,
    required this.weight,
    required this.onWeightChanged,
    required this.onSelectExercise,
    required this.weightController,
  }) : super(key: key);

  @override
  _ExerciseWeightTabState createState() => _ExerciseWeightTabState();
}

class _ExerciseWeightTabState extends State<ExerciseWeightTab> {
  @override
  Widget build(BuildContext context) {
    if (widget.exerciseValue == null || widget.exerciseValue!.isEmpty) {
      return Center(
        child: GestureDetector(
          onTap: widget.onSelectExercise,
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

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              '${widget.exerciseName}',
              style: const TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 32.0),
          const Text('무게 설정 (kg)'),
          const SizedBox(height: 32.0),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 110,
                  height: MediaQuery.of(context).size.width - 110,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: widget.weight / 100),
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
                        if (widget.weight > 0) {
                          widget.onWeightChanged(widget.weight - 1);
                          widget.weightController.text =
                              (widget.weight - 1).toString();
                        }
                      },
                    ),
                    SizedBox(
                      width: 130,
                      child: Focus(
                        onFocusChange: (hasFocus) {
                          if (!hasFocus) {
                            double newWeight =
                                double.tryParse(widget.weightController.text) ??
                                    0;
                            if (newWeight < 0) newWeight = 0;
                            if (newWeight > 500) newWeight = 500;
                            widget.onWeightChanged(newWeight);
                          }
                        },
                        child: TextField(
                          controller: widget.weightController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 34.0,
                            fontWeight: FontWeight.bold,
                          ),
                          onSubmitted: (value) {
                            double newWeight = double.tryParse(value) ?? 0;
                            if (newWeight < 0) newWeight = 0;
                            if (newWeight > 500) newWeight = 500;
                            widget.onWeightChanged(newWeight);
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      padding: const EdgeInsets.all(20),
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        if (widget.weight < 500) {
                          widget.onWeightChanged(widget.weight + 1);
                          widget.weightController.text =
                              (widget.weight + 1).toString();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
