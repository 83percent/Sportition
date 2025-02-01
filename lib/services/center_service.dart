import 'package:cloud_firestore/cloud_firestore.dart';

class CenterService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot?> getCenterByUUID(String uuid) async {
    try {
      DocumentSnapshot centerDoc =
          await _firestore.collection('centers').doc(uuid).get();
      if (centerDoc.exists) {
        return centerDoc;
      } else {
        print('No center found with the given UUID.');
        return null;
      }
    } catch (e) {
      print('Error fetching center: $e');
      return null;
    }
  }

  Future<String?> getCenterNameByUUID(String uuid) async {
    DocumentSnapshot? centerDoc = await getCenterByUUID(uuid);
    if (centerDoc != null && centerDoc.exists) {
      return centerDoc['name'] as String?;
    } else {
      return null;
    }
  }
}
