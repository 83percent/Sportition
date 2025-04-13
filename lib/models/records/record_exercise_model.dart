import 'package:sportition_center/models/records/record_model.dart';

class RecordExerciseModel {
  String exerciseId;
  String exerciseName;
  late List<RecordModel> records = [];

  RecordExerciseModel({
    required this.exerciseId,
    required this.exerciseName,
  });

  setRecord(RecordModel record) {
    records.add(record);
  }

  setRecords(List<RecordModel> records) {
    this.records = records;
  }
}
