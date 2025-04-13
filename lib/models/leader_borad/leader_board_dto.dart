class LeaderBoardDTO {
  int rank;
  final String clientUID;
  final String name;
  String gender;
  double score;

  LeaderBoardDTO({
    required this.rank,
    required this.clientUID,
    required this.name,
    required this.gender,
    required this.score,
  });
}
