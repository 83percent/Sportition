import 'package:sportition_center/models/records/record_exercise_model.dart';

class RecordDayModel {
  final String day;
  late List<RecordExerciseModel> exerciseRecords = [];

  RecordDayModel({
    required this.day,
  });

  setExercise(RecordExerciseModel exercise) {
    exerciseRecords.add(exercise);
  }

  setExercises(List<RecordExerciseModel> exercises) {
    exerciseRecords.addAll(exercises);
  }
}
