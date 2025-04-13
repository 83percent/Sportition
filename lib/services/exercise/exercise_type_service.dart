import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportition_center/models/exercise/exercise_type_dto.dart';

class ExerciseTypeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Singleton
  static final ExerciseTypeService _exerciseTypeService =
      ExerciseTypeService._internal();
  ExerciseTypeService._internal();
  factory ExerciseTypeService() {
    return _exerciseTypeService;
  }

  Future<List<ExerciseTypeDTO>> getExerciseTypes() async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('exercises_type').doc('v1').get();

    List<dynamic> types = documentSnapshot['types'];

    return types.map((element) {
      return ExerciseTypeDTO(
        name: element['name'],
        seq: element['seq'] is String
            ? int.tryParse(element['seq'])
            : element['seq'],
      );
    }).toList()
      ..sort((a, b) => (a.seq ?? 0).compareTo(b.seq ?? 0)); // seq 오름차순 정렬
  }
}
