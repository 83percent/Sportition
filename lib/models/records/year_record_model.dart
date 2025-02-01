import 'package:sportition_center/models/records/day_record_model.dart';
import 'package:sportition_center/models/records/exercise_record_detail_model.dart';
import 'package:sportition_center/models/records/exercise_record_model.dart';
import 'package:sportition_center/models/records/month_record_model.dart';

class YearRecordModel {
  String year;
  List<MonthRecordModel> monthRecords;

  YearRecordModel({required this.year, required this.monthRecords});

  get getYear => year;
  get getMonthRecords => monthRecords;

  set setYear(String year) => this.year = year;
  set setMonthRecords(List<MonthRecordModel> monthRecords) =>
      this.monthRecords = monthRecords;

  factory YearRecordModel.fromMap(String year, Map<String, dynamic> map) {
    List<MonthRecordModel> monthRecords = [];
    map.forEach((month, monthData) {
      monthRecords.add(MonthRecordModel.fromMap(month, monthData));
    });
    return YearRecordModel(year: year, monthRecords: monthRecords);
  }
}
