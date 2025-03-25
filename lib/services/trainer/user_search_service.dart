import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

class UserSearchService {
  static final Logger _logger = Logger('UserSearchService');

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Singleton
  static final UserSearchService _userSearchService =
      UserSearchService._internal();
  UserSearchService._internal();
  factory UserSearchService() {
    return _userSearchService;
  }

  /*
    * This method is used to search for users
    * Firestore에 저장된 사용자가 존재하는지 확인한다.
  */
  Future<bool> hasUser({
    String type = 'email',
    String? email,
  }) async {
    switch (type) {
      // Email로 사용자가 존재하는지 확인
      case 'email':
        {
          QuerySnapshot snapshot = await _firestore
              .collection('trainers')
              .where('email', isEqualTo: email)
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
