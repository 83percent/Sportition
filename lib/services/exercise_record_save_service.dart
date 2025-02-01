import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExerciseRecordSaveService {
  Future<void> saveRecord({
    required String uid,
    required String exerciseValue,
    required double weight,
    required int reps,
    required String userUid,
  }) async {
    final now = DateTime.now();
    final year = now.year.toString();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    final regDttm = now.toIso8601String();

    final record = {
      'weight': weight,
      'count': reps,
      'set': 1, // 기본값으로 1 설정, Firestore에서 가져와서 업데이트 필요
      'user_uid': userUid,
      'reg_dttm': regDttm,
    };

    final docRef = FirebaseFirestore.instance
        .collection('clients')
        .doc(uid)
        .collection('records')
        .doc(year);

    await docRef.set({
      month: {
        day: {
          exerciseValue: FieldValue.arrayUnion([record])
        }
      }
    }, SetOptions(merge: true));

    if (exerciseValue == 'deadlift' ||
        exerciseValue == 'benchPress' ||
        exerciseValue == 'squat') {
      final prefs = await SharedPreferences.getInstance();
      final centerUid = prefs.getString('centerUID') ?? '';

      if (centerUid.isEmpty) {
        return;
      }

      final centerDocRef =
          FirebaseFirestore.instance.collection('centers').doc(centerUid);

      final centerDoc = await centerDocRef.get();
      final existingRecords = centerDoc.data()?['records'] ?? {};

      final userRecords = existingRecords[uid] ?? {};
      final existingWeight = userRecords[exerciseValue] ?? 0.0;

      if (weight > existingWeight) {
        userRecords[exerciseValue] = weight;
        existingRecords[uid] = userRecords;

        await centerDocRef.update({
          'records': existingRecords,
        });
      }
    }
  }
}
