import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportition_center/models/leader_borad/leader_board_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaderBoardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<LeaderBoardModel>> getLeaderBoard() async {
    final prefs = await SharedPreferences.getInstance();
    final centerUID = prefs.getString('centerUID') ?? '';

    if (centerUID == '') {
      return [];
    }

    final DocumentSnapshot centerDoc =
        await _firestore.collection('centers').doc(centerUID).get();

    if (!centerDoc.exists) {
      return [];
    }

    final docData = centerDoc.data() as Map<String, dynamic>;

    if (!docData.containsKey('records') || !docData.containsKey('clients')) {
      return [];
    }

    final Map<String, dynamic> records = centerDoc['records'];
    final List<dynamic> clients = centerDoc['clients'];

    return records.entries.map((entry) {
      final clientData = entry.value;
      final client = clients.firstWhere((client) => client['uid'] == entry.key);

      return LeaderBoardModel(
        name: client['name'],
        uid: entry.key,
        all: (clientData['squat'] ?? 0) +
            (clientData['benchPress'] ?? 0) +
            (clientData['deadlift'] ?? 0),
        squat: clientData['squat'] ?? 0,
        benchpress: clientData['benchPress'] ?? 0,
        deadlift: clientData['deadlift'] ?? 0,
      );
    }).toList();
  }

  Future<Map<String, dynamic>?> getCenterDocData() async {
    final prefs = await SharedPreferences.getInstance();
    final centerUID = prefs.getString('centerUID') ?? '';

    if (centerUID.isEmpty) {
      return null;
    }

    final DocumentSnapshot centerDoc =
        await _firestore.collection('centers').doc(centerUID).get();

    if (!centerDoc.exists) {
      return null;
    }

    return centerDoc.data() as Map<String, dynamic>?;
  }

  List<LeaderBoardModel> getLeaderBoardFromData(Map<String, dynamic> docData) {
    if (!docData.containsKey('records') || !docData.containsKey('clients')) {
      return [];
    }

    final Map<String, dynamic> records = docData['records'];
    final List<dynamic> clients = docData['clients'];

    return records.entries.map((entry) {
      final clientData = entry.value;
      final client = clients.firstWhere((client) => client['uid'] == entry.key);

      return LeaderBoardModel(
        name: client['name'],
        uid: entry.key,
        all: (clientData['squat'] ?? 0) +
            (clientData['benchPress'] ?? 0) +
            (clientData['deadlift'] ?? 0),
        squat: clientData['squat'] ?? 0,
        benchpress: clientData['benchPress'] ?? 0,
        deadlift: clientData['deadlift'] ?? 0,
      );
    }).toList();
  }

  List<LeaderBoardModel> getAllLeaderBoardListFromData(
      Map<String, dynamic> docData) {
    final leaderBoard = getLeaderBoardFromData(docData);
    leaderBoard.sort((a, b) => b.all.compareTo(a.all));
    return leaderBoard;
  }

  List<LeaderBoardModel> getSquatLeaderBoardListFromData(
      Map<String, dynamic> docData) {
    final leaderBoard = getLeaderBoardFromData(docData);
    leaderBoard.sort((a, b) => b.squat.compareTo(a.squat));
    return leaderBoard;
  }

  List<LeaderBoardModel> getBenchPressLeaderBoardListFromData(
      Map<String, dynamic> docData) {
    final leaderBoard = getLeaderBoardFromData(docData);
    leaderBoard.sort((a, b) => b.benchpress.compareTo(a.benchpress));
    return leaderBoard;
  }

  List<LeaderBoardModel> getDeadliftLeaderBoardListFromData(
      Map<String, dynamic> docData) {
    final leaderBoard = getLeaderBoardFromData(docData);
    leaderBoard.sort((a, b) => b.deadlift.compareTo(a.deadlift));
    return leaderBoard;
  }

  Future<List<LeaderBoardModel>> getAllLeaderBoardList() async {
    final leaderBoard = await getLeaderBoard();
    leaderBoard.sort((a, b) => b.all.compareTo(a.all));
    return leaderBoard;
  }

  Future<List<LeaderBoardModel>> getSquatLeaderBoardList() async {
    final leaderBoard = await getLeaderBoard();
    leaderBoard.sort((a, b) => b.squat.compareTo(a.squat));
    return leaderBoard;
  }

  Future<List<LeaderBoardModel>> getBenchPressLeaderBoardList() async {
    final leaderBoard = await getLeaderBoard();
    leaderBoard.sort((a, b) => b.benchpress.compareTo(a.benchpress));
    return leaderBoard;
  }

  Future<List<LeaderBoardModel>> getDeadliftLeaderBoardList() async {
    final leaderBoard = await getLeaderBoard();
    leaderBoard.sort((a, b) => b.deadlift.compareTo(a.deadlift));
    return leaderBoard;
  }
}
