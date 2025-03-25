import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportition_center/models/exercise/exercise_type_dto.dart';
import 'package:sportition_center/services/trainer/trainer_util_service.dart';

class ExerciseTypeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ExerciseTypeDTO> _exerciseTypeList = [];

  // Singleton
  static final ExerciseTypeService _exerciseTypeService =
      ExerciseTypeService._internal();
  ExerciseTypeService._internal();
  factory ExerciseTypeService() {
    return _exerciseTypeService;
  }

  /// GET Exercise TYPE
  Future<List<ExerciseTypeDTO>> getExerciseTypeList() async {
    List<ExerciseTypeDTO> exerciseTypeList = [];
    if (exerciseTypeList.isNotEmpty) {
      return exerciseTypeList;
    } else {
      /// Firestore / exericises
      exerciseTypeList = await _firestore.collection('exercises').get().then(
        (QuerySnapshot querySnapshot) {
          return querySnapshot.docs.map((doc) {
            return ExerciseTypeDTO(
              exerciseName: doc['exerciseName'],
              regUID: doc['reg_uid'],
              regDttm: doc['reg_dttm'],
            );
          }).toList();
        },
      );
    }
    return exerciseTypeList;
  }

  /// ADD Exercise TYPE
  Future<void> addExerciseType(String exerciseName) async {
    String? trainerUID = await TrainerUtilService().getTrainerUID();
    if (trainerUID == null) {
      throw Exception('Trainer UID is null');
    }

    try {
      await _firestore.collection('exercises').add({
        'exerciseName': exerciseName,
        'reg_uid': trainerUID,
        'reg_dttm': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding exercise type: $e');
    }
  }

  /// UPDATE Exercise TYPE

  /// DELETE Exercise TYPE
}
