import 'package:sportition_center/models/records/exercise_record_detail_model.dart';

class ExerciseRecordModel {
  String value;
  String? name;
  List<ExerciseRecordDetailModel> records;

  ExerciseRecordModel({
    required this.value,
    this.name,
    required this.records,
  });

  get getValue => value;
  get getName => name;
  get getRecords => records;

  set setValue(String value) => this.value = value;
  set setName(String name) => this.name = name;
  set setRecords(List<ExerciseRecordDetailModel> records) =>
      this.records = records;

  factory ExerciseRecordModel.fromMap(String exerciseValue, List<dynamic> map) {
    List<ExerciseRecordDetailModel> records = [];

    for (var record in map) {
      records.add(ExerciseRecordDetailModel.fromMap(record));
    }

    return ExerciseRecordModel(
      value: exerciseValue,
      name: null,
      records: records,
    );
  }
}
