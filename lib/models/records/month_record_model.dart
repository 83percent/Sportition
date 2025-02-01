import 'package:sportition_center/models/records/day_record_model.dart';

class MonthRecordModel {
  String month;
  List<DayRecordModel> dayRecords;

  MonthRecordModel({required this.month, required this.dayRecords});

  get getMonth => month;
  get getDayRecords => dayRecords;

  factory MonthRecordModel.fromMap(String month, Map<String, dynamic> map) {
    List<DayRecordModel> dayRecords = [];
    map.forEach((day, dayData) {
      dayRecords.add(DayRecordModel.fromMap(day, dayData));
    });
    return MonthRecordModel(month: month, dayRecords: dayRecords);
  }
}
