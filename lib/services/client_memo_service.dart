import 'package:cloud_firestore/cloud_firestore.dart';

class ClientMemoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getClientMemo(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        return data != null && data.containsKey('memo')
            ? data['memo'] ?? ""
            : "";
      } else {
        return "";
      }
    } catch (e) {
      print('Error getting client memo: $e');
      return null;
    }
  }

  Future<void> saveClientMemo(String uid, String memo) async {
    try {
      await _firestore.collection('users').doc(uid).update({'memo': memo});
    } catch (e) {
      print('Error saving client memo: $e');
      throw e;
    }
  }
}
