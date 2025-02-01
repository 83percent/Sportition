import 'dart:ffi';

class ExerciseRecordDetailModel {
  String count;
  String weight;
  String? regDttm;
  String? userUid;

  ExerciseRecordDetailModel({
    required this.count,
    required this.weight,
    this.regDttm,
    this.userUid,
  });

  get getCount => count;
  get getWeigth => weight;
  get getRegDttm => regDttm;
  get getUserUid => userUid;

  set setCount(String count) => this.count = count;
  set setWeigth(String weight) => this.weight = weight;
  set setRegDttm(String regDttm) => this.regDttm = regDttm;
  set setUserUid(String userUid) => this.userUid = userUid;

  factory ExerciseRecordDetailModel.fromMap(Map<String, dynamic> map) {
    return ExerciseRecordDetailModel(
      count: map['count'].toString() ?? '0',
      weight: map['weight'].toString() ?? '0',
      regDttm: map['regDttm'],
      userUid: map['userUid'],
    );
  }
}
