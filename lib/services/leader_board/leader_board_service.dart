import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportition_center/models/leader_borad/leader_board_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportition_center/models/leader_borad/leader_board_raw_dto.dart';

class LeaderBoardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Singleton
  static final LeaderBoardService _leaderBoardService =
      LeaderBoardService._internal();
  LeaderBoardService._internal();
  factory LeaderBoardService() {
    return _leaderBoardService;
  }

  Future<List<LeaderBoardDTO>> getLeaderBoardList(
    String gender,
    String type,
  ) async {
    if (gender == '' || type == '') {
      return [];
    }

    // Center UID 가져오기
    String centerUID = await _getCenterUID();

    // Firestore에서 회원 데이터 가져오기
    QuerySnapshot snapshot = await _firestore
        .collection('centers')
        .doc(centerUID)
        .collection('clients')
        .get();

    List<LeaderBoardRawDTO> leaderBoardRawList = [];

    // 각 문서에서 records 필드 값을 Map<String, dynamic>에 추가
    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Map<String, dynamic> records = {};
      if (data.containsKey('records')) {
        records = {
          'benchpress': data['records']['benchpress'] ?? 0.0,
          'squat': data['records']['squat'] ?? 0.0,
          'deadlift': data['records']['deadlift'] ?? 0.0,
        };
      } else {
        records = {
          'benchpress': 0.0,
          'squat': 0.0,
          'deadlift': 0.0,
        };
      }

      leaderBoardRawList.add(LeaderBoardRawDTO(
        clientUID: doc.id,
        name: data['clientName'],
        gender: data['gender'] ?? 'unknown',
        benchpress: records['benchpress'] ?? 0.0,
        squat: records['squat'] ?? 0.0,
        deadlift: records['deadlift'] ?? 0.0,
      ));
    }

    // 동일 성별로 필터링
    if (gender != 'all') {
      leaderBoardRawList = leaderBoardRawList
          .where((record) => record.gender == gender)
          .toList();
    }

    // 유형별 정렬
    leaderBoardRawList.sort((a, b) {
      double aValue = 0.0;
      double bValue = 0.0;
      switch (type) {
        case 'all':
          aValue = a.benchpress + a.squat + a.deadlift;
          bValue = b.benchpress + b.squat + b.deadlift;
          break;
        case 'benchpress':
          aValue = a.benchpress;
          bValue = b.benchpress;
          break;
        case 'squat':
          aValue = a.squat;
          bValue = b.squat;
          break;
        case 'deadlift':
          aValue = a.deadlift;
          bValue = b.deadlift;
          break;
        default:
          break;
      }

      return bValue.compareTo(aValue); // 내림차순 정렬
    });

    List<LeaderBoardDTO> leaderBoardDTOList = [];

    // LeaderBoardRawDTO를 LeaderBoardDTO로 변환
    for (int i = 0; i < leaderBoardRawList.length; i++) {
      var raw = leaderBoardRawList[i];
      leaderBoardDTOList.add(LeaderBoardDTO(
        rank: i + 1, // 등수 설정
        clientUID: raw.clientUID,
        name: raw.name,
        gender: raw.gender ?? 'unknown',
        score: type == 'all'
            ? raw.benchpress + raw.squat + raw.deadlift
            : type == 'benchpress'
                ? raw.benchpress
                : type == 'squat'
                    ? raw.squat
                    : raw.deadlift,
      ));
    }

    return leaderBoardDTOList;
  }

  Future<List<String>> getClientUIDs() async {
    List<String> clientUIDs = [];

    // Center UID 가져오기
    String centerUID = await _getCenterUID();

    // Firestore에서 회원 정보 가져오기
    QuerySnapshot snapshot = await _firestore
        .collection('centers')
        .doc(centerUID)
        .collection('clients')
        .get();

    // 회원 문서 ID를 List<String> 형태로 변환
    for (var doc in snapshot.docs) {
      clientUIDs.add(doc.id);
    }

    return clientUIDs;
  }

  Future<String> _getCenterUID() async {
    // SharedPreferences에서 centerUID를 가져오는 로직
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? centerUID = prefs.getString('centerUID');
    if (centerUID == null) {
      throw Exception('센터 UID를 찾을 수 없습니다.');
    }
    return centerUID;
  }
}
