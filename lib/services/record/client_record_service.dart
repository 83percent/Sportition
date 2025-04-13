import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import 'package:sportition_center/models/records/record_day_model.dart';
import 'package:sportition_center/models/records/record_exercise_model.dart';
import 'package:sportition_center/models/records/record_group_model.dart';
import 'package:sportition_center/models/records/record_model.dart';

class ClientRecordService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final Logger _logger = Logger('JoinPage');

  // Get Client Exercise Record
  Future<List<RecordGroupModel>> getClientExerciseRecord(
      {required String clientUid}) async {
    List<RecordGroupModel> records = [];

    final docRef = _firestore
        .collection('users')
        .doc(clientUid)
        .collection('exerciseRecords');

    final querySnapshot = await docRef.get();
    try {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        RecordGroupModel recordGroup = RecordGroupModel(
          yearMonth: doc.id,
        );

        /*
        docId : yearMonth (ex. 2025-04)
        {
          '13' (day) : {
            'exercises' : [
              {
                'exerciseId' : 'exerciseId',
                'exerciseName' : 'exerciseName',
                'records' : [
                  'count' : 10,
                  'weight' : 20,
                ]
              },
              {
              'exerciseId' : 'exerciseId',
                'exerciseName' : 'exerciseName',
                'records' : [
                  'count' : 10,
                  'weight' : 20,
                ]
              }
            ]
          }
        }
        */

        for (var day in data.keys) {
          if (day == 'createdAt') continue; // createdAt은 제외
          Map<String, dynamic> dayData = data[day] as Map<String, dynamic>;
          List<RecordDayModel> recordDayDataList = [];
          RecordDayModel recordDay = RecordDayModel(
            day: day,
          );

          List<dynamic> exercises = dayData['exercises'] ?? [];
          List<RecordExerciseModel> recordExerciseDataList = [];
          for (var exercise in exercises) {
            String exerciseId = exercise['exerciseId'];
            String exerciseName = exercise['exerciseName'];
            RecordExerciseModel recordExercise = RecordExerciseModel(
              exerciseId: exerciseId,
              exerciseName: exerciseName,
            );

            List<dynamic> recordsData = exercise['records'] ?? [];
            List<RecordModel> recordsDataList = [];
            for (var record in recordsData) {
              RecordModel recordModel = RecordModel(
                /*
                count: record['count'] is int
                    ? record['count'].toString()
                    : record['count'] ?? '0',
                weight: record['weight'] is int
                    ? record['weight'].toString()
                    : record['weight'] ?? '0',
                    */
                count: record['count'].toString() ?? '0',
                weight: record['weight'].toString() ?? '0',
              );

              recordsDataList.add(recordModel);
            }
            recordExercise.setRecords(recordsDataList);
            recordExerciseDataList.add(recordExercise);
          }
          recordDay.setExercises(recordExerciseDataList);
          recordDayDataList.add(recordDay);
          recordGroup.setdays(recordDayDataList);
        }

        records.add(recordGroup);
      }
    } catch (e) {
      _logger.severe('Error getting client exercise records: $e');
    }
    return records;
  }
}
