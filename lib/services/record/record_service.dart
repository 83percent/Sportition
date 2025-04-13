import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecordService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger('LoginService');

  // Singleton
  static final RecordService _recordService = RecordService._internal();
  RecordService._internal();
  factory RecordService() {
    return _recordService;
  }

  Future<void> save({
    required String uid,
    required Map<String, dynamic> data, // 저장할 데이터
  }) async {
    // ##### 추가 #####
    // 오늘 날짜를 연-월과 일(day)로 구분
    final now = DateTime.now();
    final yearMonth = DateFormat('yyyy-MM').format(now); // ex. 2025-04
    final day = DateFormat('d').format(now); // ex. 7

    // ##### 추가 #####
    // 연-월 문서 참조
    final yearMonthDocRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('exerciseRecords')
        .doc(yearMonth);

    // ##### 추가 #####
    // 연-월 문서가 존재하는지 확인
    final yearMonthDocSnapshot = await yearMonthDocRef.get();

    if (!yearMonthDocSnapshot.exists) {
      // 연-월 문서가 없으면 생성
      await yearMonthDocRef.set({
        'createdAt': FieldValue.serverTimestamp(), // 생성 시간 기록
      });
    }

    // ##### 추가 #####
    // 오늘 날짜 데이터를 Map 형태로 가져오기
    final yearMonthData = yearMonthDocSnapshot.data() ?? {};
    final dayData = yearMonthData[day] as Map<String, dynamic>? ??
        {
          'exercises': [],
        };

    // ##### 추가 #####
    // exercises 배열 가져오기
    final exercises =
        List<Map<String, dynamic>>.from(dayData['exercises'] ?? []);

    // 같은 exerciseId가 있는지 확인
    final existingExercise = exercises.firstWhere(
      (exercise) => exercise['exerciseId'] == data['exerciseId'],
      orElse: () => {},
    );

    if (existingExercise.isNotEmpty) {
      // 같은 exerciseId가 있으면 records에 추가
      existingExercise['records'].add({
        'count': data['count'],
        'weight': data['weight'],
      });
    } else {
      // 같은 exerciseId가 없으면 새로 추가
      exercises.add({
        'exerciseId': data['exerciseId'],
        'exerciseName': data['exerciseName'],
        'records': [
          {
            'count': data['count'],
            'weight': data['weight'],
          }
        ],
      });
    }

    // ##### 추가 #####
    // 오늘 날짜 데이터를 업데이트
    dayData['exercises'] = exercises;

    // ##### 추가 #####
    // Firestore에 저장
    await yearMonthDocRef.update({
      day: dayData,
    });

    if (isMainRecords(exerciseName: data['exerciseName'])) {
      // 메인 운동 기록 저장
      await setMainRecords(uid: uid, data: data);

      // 센터 운동 기록 저장
      await setCenterClientRecord(uid: uid, data: data);
    }
  }

  bool isMainRecords({required String exerciseName}) {
    /*
      exerciseName에 '스쿼트', '벤치프레스', '데드리프트'가 포함되어 있는지 확인
      포함되어 있다면 true를 반환
      포함되어 있지 않다면 false를 반환
    */
    final mainExercises = ['스쿼트', '벤치프레스', '벤치 프레스', '데드리프트'];
    for (String mainExercise in mainExercises) {
      if (exerciseName.contains(mainExercise)) {
        return true;
      }
    }
    // 만약 '스쿼트', '벤치프레스', '데드리프트'가 포함되어 있지 않다면 false를 반환
    return false;
  }

  Future<void> setMainRecords({
    required String uid,
    required Map<String, dynamic> data, // 저장할 데이터
  }) async {
    /*
      firestore users/{uid}/mainRecords/{연-월} 문서에
      일(day)별로 '스쿼트', '벤치프레스', '데드리프트'의 최대 중량을 저장

      key : value
      - key
        - '스쿼트'    : squat
        - '벤치프레스' : benchpress
        - '데드리프트' : deadlift

      ex)
      users/user123/mainRecords/2025-04

      {
        '1' : {
          squat : 100,
          deadlift : 130
        },
        '7' : {
          deadlift : 120
        }
      }

      이때, 2025년 4월 7일에 데드리프트 100kg을 기록 하는 경우,
      기존에 120kg가 당일 최대기록이므로 update 하지 않는다.
     */

    // data exerciseName을 영어로 변경
    // 예시: '스쿼트' -> 'squat'
    // 예시: '벤치프레스' -> 'benchpress'
    // 예시: '데드리프트' -> 'deadlift'
    String exerciseName = data['exerciseName'];
    String exerciseValue = '';
    if (exerciseName.contains('스쿼트')) {
      exerciseValue = 'squat';
    } else if (exerciseName.contains('벤치 프레스') ||
        exerciseName.contains('벤치프레스')) {
      // '벤치 프레스'와 '벤치프레스' 모두 처리
      exerciseValue = 'benchpress';
    } else if (exerciseName.contains('데드리프트')) {
      exerciseValue = 'deadlift';
    }

    // ##### 추가 #####
    // 오늘 날짜를 연-월과 일(day)로 구분
    final now = DateTime.now();
    final yearMonth = DateFormat('yyyy-MM').format(now); // ex. 2025-04
    final day = DateFormat('d').format(now); // ex. 7

    // ##### 추가 #####
    // 연-월 문서 참조
    final yearMonthDocRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('mainRecords')
        .doc(yearMonth);

    // ##### 추가 #####
    // 연-월 문서가 존재하는지 확인
    final yearMonthDocSnapshot = await yearMonthDocRef.get();
    if (!yearMonthDocSnapshot.exists) {
      // 연-월 문서가 없으면 생성
      await yearMonthDocRef.set({});
    }

    // 오늘 일(day) 데이터 가져오기
    final yearMonthData = yearMonthDocSnapshot.data() ?? {};
    final dayData = yearMonthData[day] as Map<String, dynamic>? ??
        {
          'squat': 0,
          'benchpress': 0,
          'deadlift': 0,
        };

    // 저장하려는 운동과 비교하여 최고 중량인지 확인
    // 만약 최고 중량이라면 저장
    if (data['weight'] > dayData[exerciseValue]) {
      // 최고 중량이면 저장
      dayData[exerciseValue] = data['weight'];
    } else {
      // 최고 중량이 아니면 저장하지 않음
      return;
    }

    // 저장
    await yearMonthDocRef.update({
      day: dayData,
    });
  }

  Future<void> setCenterClientRecord({
    required String uid,
    required Map<String, dynamic> data, // 저장할 데이터
  }) async {
    try {
      String exerciseName = data['exerciseName'];
      String exerciseValue = '';
      if (exerciseName.contains('스쿼트')) {
        exerciseValue = 'squat';
      } else if (exerciseName.contains('벤치 프레스') ||
          exerciseName.contains('벤치프레스')) {
        // '벤치 프레스'와 '벤치프레스' 모두 처리
        exerciseValue = 'benchpress';
      } else if (exerciseName.contains('데드리프트')) {
        exerciseValue = 'deadlift';
      }

      // Center UID 가져오기
      String centerUID = await _getCenterUID();

      DocumentSnapshot snapshot = await _firestore
          .collection('centers')
          .doc(centerUID)
          .collection('clients')
          .doc(uid)
          .get();

      // records 데이터 갖고오기
      Map<String, dynamic> records = snapshot.data() as Map<String, dynamic>;

      // records 데이터가 없으면 초기화
      if (records['records'] == null) {
        records['records'] = {
          'squat': 0.0,
          'benchpress': 0.0,
          'deadlift': 0.0,
        };
      }

      // 저장하려는 운동과 비교하여 최고 중량인지 확인
      // 만약 최고 중량이라면 저장
      if (data['weight'] > records['records'][exerciseValue]) {
        // 최고 중량이면 저장
        records['records'][exerciseValue] = data['weight'];
      } else {
        // 최고 중량이 아니면 저장하지 않음
        return;
      }

      // Firestore에 저장
      await _firestore
          .collection('centers')
          .doc(centerUID)
          .collection('clients')
          .doc(uid)
          .update({
        'records': records['records'],
      });
    } catch (e) {
      // 예외 처리
      _logger.severe('Error saving center client record: $e');
      throw Exception('센터 클라이언트 기록 저장에 실패했습니다.');
    }
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
