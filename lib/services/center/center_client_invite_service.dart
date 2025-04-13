import 'package:cloud_firestore/cloud_firestore.dart';

class CenterClientInviteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Singleton
  static final CenterClientInviteService _centerClientInviteService =
      CenterClientInviteService._internal();
  CenterClientInviteService._internal();
  factory CenterClientInviteService() {
    return _centerClientInviteService;
  }

  Future<List> getCenterClientInviteList() async {
    String centerUID = '';

    // SharedPreferences에서 centerUID를 가져오는 로직

    // Firestore에서 초대 요청목록 조회하기l

    List inviteList = [];

    QuerySnapshot snapshot = await _firestore
        .collection('centers')
        .doc(centerUID)
        .collection('client_invite')
        .get();

    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      inviteList.add(data);
    }

    return inviteList;
  }
}
