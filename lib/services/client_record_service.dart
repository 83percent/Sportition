import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import 'package:sportition_center/models/records/year_record_model.dart';

class ClientRecordService {
  String uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final Logger _logger = Logger('JoinPage');

  ClientRecordService({required this.uid}) {
    uid = uid;
  }

  // Get Client Exercise Record
  Future<List<YearRecordModel>> getClientExerciseRecord() async {
    List<YearRecordModel> records = [];

    final docRef =
        _firestore.collection('clients').doc(uid).collection('records');

    try {
      final querySnapshot = await docRef.get();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data();
        String year = doc.id;

        YearRecordModel yearRecord = YearRecordModel.fromMap(year, data);
        records.add(yearRecord);
      }

      records.sort((a, b) => b.year.compareTo(a.year));
      _logger.info('Client Exercise Records: $records');
    } catch (e) {
      _logger.severe('Failed to get client exercise records: $e');
    }

    return records;
  }
}
