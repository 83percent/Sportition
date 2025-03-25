import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

class CenterSearchService {
  static final Logger _logger = Logger('CenterSearchService');

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Singleton
  static final CenterSearchService _centerSearchService =
      CenterSearchService._internal();
  CenterSearchService._internal();
  factory CenterSearchService() {
    return _centerSearchService;
  }

  /*
    * This method is used to search for centers
    * Firestore에 저장된 센터가 존재하는지 확인한다.
  */

  Future<bool> hasCenter({
    String type = 'uid',
    String? centerUID,
    String? centerName,
  }) async {
    switch (type) {
      // UID로 센터가 존재하는지 확인
      case 'uid':
        {
          DocumentSnapshot snapshot =
              await _firestore.collection('centers').doc(centerUID).get();
          return snapshot.exists;
        }

      // 센터명으로 센터가 존재하는지 확인
      case 'name':
        {
          QuerySnapshot snapshot = await _firestore
              .collection('centers')
              .where('name', isEqualTo: centerName)
              .get();
          return snapshot.docs.isNotEmpty;
        }
      default:
        {
          return false;
        }
    }
  }
}
