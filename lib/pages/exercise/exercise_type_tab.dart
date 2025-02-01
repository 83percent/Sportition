import 'package:flutter/material.dart';
import 'package:sportition_center/models/exercise/exercise_model.dart';
import 'package:sportition_center/pages/exercise/exercise_list_widget.dart';

class ExerciseTypeTab extends StatelessWidget {
  final Function(Exercise) onExerciseSelected;

  const ExerciseTypeTab({Key? key, required this.onExerciseSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExerciseListWidget(onExerciseSelected: onExerciseSelected);
  }
}
