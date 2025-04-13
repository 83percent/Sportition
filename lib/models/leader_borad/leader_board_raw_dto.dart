class LeaderBoardRawDTO {
  String clientUID;
  String name;
  String gender;
  double benchpress;
  double squat;
  double deadlift;

  LeaderBoardRawDTO({
    required this.clientUID,
    required this.name,
    required this.gender,
    required this.benchpress,
    required this.squat,
    required this.deadlift,
  });
}
