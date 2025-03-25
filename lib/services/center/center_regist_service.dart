import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import 'package:sportition_center/models/center/center_regist_dto.dart';

class CenterRegistService {
  static final Logger _logger = Logger('CenterRegistService');

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Singleton
  static final CenterRegistService _centerRegistService =
      CenterRegistService._internal();
  CenterRegistService._internal();
  factory CenterRegistService() {
    return _centerRegistService;
  }

  /*
    * This method is used to register a center
    * 센터를 Firestore에 등록한다.
  */
  Future<String> registCenter(CenterRegistDTO centerRegistDTO) async {
    String registCenterUID = '';
    try {
      DocumentReference docRef = await _firestore.collection('centers').add({
        'name': centerRegistDTO.centerName,
        'regDttm': FieldValue.serverTimestamp(),
      });
      registCenterUID = docRef.id;
    } catch (e) {
      _logger.severe('Failed to register center: $e');
      throw Exception('Failed to register center');
    }
    return registCenterUID;
  }
}
