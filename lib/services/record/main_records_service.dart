import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import 'package:sportition_center/models/records/chart/main_record_dto.dart';

class MainRecordsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final Logger _logger = Logger('RecordService');

  // Singleton
  static final MainRecordsService _recordService =
      MainRecordsService._internal();
  MainRecordsService._internal();
  factory MainRecordsService() {
    return _recordService;
  }

  Future<List<MainRecordDTO>> getMainRecordList(String uid) async {
    List<MainRecordDTO> resultList = [];

    try {
      DateTime now = DateTime.now();
      DateTime oneYearAgo = DateTime(now.year - 1, now.month + 1, 1);

      for (DateTime date = oneYearAgo;
          date.isBefore(DateTime(now.year, now.month + 1, 1));
          date = DateTime(date.year, date.month + 1, 1)) {
        String collectionId =
            '${date.year}-${date.month.toString().padLeft(2, '0')}';
        DocumentSnapshot mainRecordSnapshot = await _firestore
            .collection('users')
            .doc(uid)
            .collection('mainRecords')
            .doc(collectionId)
            .get();

        if (mainRecordSnapshot.exists) {
          Map<String, dynamic> data =
              mainRecordSnapshot.data() as Map<String, dynamic>;
          List<MapEntry<String, dynamic>> sortedEntries = data.entries.toList()
            ..sort((a, b) => a.key.compareTo(b.key));

          for (var entry in sortedEntries) {
            String day = entry.key;
            Map<String, dynamic> exercises = entry.value;
            exercises.forEach((exerciseType, weight) {
              if (weight.toString() != '0') {
                // ##### 수정 #####
                // weight가 double인 경우 반올림하여 int로 변환 후 String으로 변환
                String roundedWeight =
                    (weight is double ? weight.round() : weight as int)
                        .toString();

                resultList.add(MainRecordDTO(
                  date:
                      '${date.month.toString().padLeft(2, '0')}-${day.toString()}',
                  exerciseType: exerciseType.toString(),
                  weight: roundedWeight,
                ));
              }
            });
          }
        }
      }
    } catch (e) {
      _logger.severe('Error: $e');
    }

    return resultList;
  }

  Future<List<MainRecordDTO>> getMainRecordListByExerciseType({
    required String uid,
    required String exerciseType,
  }) async {
    List<MainRecordDTO> resultList = [];

    try {
      List<MainRecordDTO> records = await getMainRecordList(uid);
      resultList = records
          .where((element) => element.exerciseType == exerciseType)
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    } catch (e) {
      _logger.severe('Error: $e');
    }

    if (resultList.length <= 1) {
      return [];
    }
    return resultList;
  }
}
