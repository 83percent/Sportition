import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportition_center/models/exercise/exercise_dto.dart';
import 'package:sportition_center/models/exercise/exercise_type_dto.dart';
import 'package:sportition_center/services/trainer/trainer_util_service.dart';

class ExerciseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ExerciseTypeDTO> _exerciseTypeList = [];

  // Singleton
  static final ExerciseService _exerciseService = ExerciseService._internal();
  ExerciseService._internal();
  factory ExerciseService() {
    return _exerciseService;
  }

  /// GET Exercise
  Future<List<ExerciseDTO>> getExerciseList() async {
    List<ExerciseDTO> exerciseTypeList = [];
    if (exerciseTypeList.isNotEmpty) {
      return exerciseTypeList;
    } else {
      /// Firestore / exericises
      exerciseTypeList = await _firestore.collection('exercises').get().then(
        (QuerySnapshot querySnapshot) {
          return querySnapshot.docs.map((doc) {
            return ExerciseDTO(
              exerciseUID: doc.id,
              exerciseName: doc['exerciseName'],
              type: doc['type'],
            );
          }).toList();
        },
      );
    }
    return exerciseTypeList;
  }

  /// ADD Exercise
  Future<void> addExercise(String exerciseName, String type) async {
    String? trainerUID = await TrainerUtilService().getTrainerUID();
    if (trainerUID == null) {
      throw Exception('Trainer UID is null');
    }

    try {
      await _firestore.collection('exercises').add({
        'exerciseName': exerciseName,
        'type': type,
        'reg_uid': trainerUID,
        'reg_dttm': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding exercise type: $e');
    }
  }

  /// CHECK Exercise NAME DUPLICATION
  Future<bool> isExerciseNameDuplicate(String exerciseName) async {
    try {
      final querySnapshot = await _firestore
          .collection('exercises')
          .where('exerciseName', isEqualTo: exerciseName)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking exercise name duplication: $e');
      return false;
    }
  }

  /// UPDATE Exercise

  /// DELETE Exercise
}
