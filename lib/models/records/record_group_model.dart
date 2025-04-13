import 'package:sportition_center/models/records/record_day_model.dart';

class RecordGroupModel {
  final String yearMonth;
  final List<RecordDayModel> days = [];

  RecordGroupModel({
    required this.yearMonth,
  });

  setExercise(RecordDayModel day) {
    days.add(day);
  }

  setdays(List<RecordDayModel> days) {
    this.days.addAll(days);
  }
}
