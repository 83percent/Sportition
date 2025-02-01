import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ExerciseDataUtil {
  static final ExerciseDataUtil _instance = ExerciseDataUtil._internal();
  Map<String, dynamic>? _exercises;

  factory ExerciseDataUtil() {
    return _instance;
  }

  ExerciseDataUtil._internal();

  Future<void> _loadExercises() async {
    final String response =
        await rootBundle.loadString('lib/data/exercises.json');
    final List<dynamic> data = json.decode(response);
    _exercises = {for (var exercise in data) exercise['value']: exercise};
  }

  Future<String?> getExerciseName(String value) async {
    if (_exercises == null) {
      await _loadExercises();
    }
    return _exercises?[value]?['name'];
  }
}
