class ExerciseTypeDTO {
  String? exerciseUID;
  String exerciseName;
  String? regUID;
  String? regDttm;

  ExerciseTypeDTO({
    this.exerciseUID,
    required this.exerciseName,
    this.regUID,
    this.regDttm,
  });
}
