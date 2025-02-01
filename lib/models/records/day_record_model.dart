import 'package:sportition_center/models/records/exercise_record_model.dart';

class DayRecordModel {
  String day;
  List<ExerciseRecordModel> exerciseRecords;

  DayRecordModel({required this.day, required this.exerciseRecords});

  get getDay => day;
  get getExerciseRecords => exerciseRecords;

  set setDay(String day) => this.day = day;
  set setExerciseRecords(List<ExerciseRecordModel> exerciseRecords) =>
      this.exerciseRecords = exerciseRecords;

  factory DayRecordModel.fromMap(String day, Map<String, dynamic> map) {
    List<ExerciseRecordModel> exerciseRecords = [];
    map.forEach((exerciseValue, exerciseList) {
      exerciseRecords
          .add(ExerciseRecordModel.fromMap(exerciseValue, exerciseList));
    });
    return DayRecordModel(day: day, exerciseRecords: exerciseRecords);
  }
}
