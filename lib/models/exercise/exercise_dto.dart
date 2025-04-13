class ExerciseDTO {
  String? exerciseUID;
  String exerciseName;
  String type;
  String? regUID;
  String? regDttm;

  ExerciseDTO({
    this.exerciseUID,
    required this.exerciseName,
    required this.type,
    this.regUID,
    this.regDttm,
  });
}
