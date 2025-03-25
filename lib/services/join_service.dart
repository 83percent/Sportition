import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sportition_center/models/user/join_model.dart';

class JoinService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> register(JoinModel joinModel) async {
    await registerTrainer(joinModel);
  }

  Future<void> registerTrainer(JoinModel joinModel) async {
    // Center
    if (joinModel.centerUUID != null) {
      DocumentSnapshot centerDoc = await _firestore
          .collection('centers')
          .doc(joinModel.centerUUID)
          .get();

      if (!centerDoc.exists) {
        throw Exception('존재하지 않는 센터입니다.');
      }
    } else if (joinModel.centerName != null) {
      QuerySnapshot centerQuery = await _firestore
          .collection('centers')
          .where('name', isEqualTo: joinModel.centerName)
          .get();

      if (centerQuery.docs.isNotEmpty) {
        throw Exception('이미 존재하는 센터입니다.');
      }
    }

    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: joinModel.email,
      password: joinModel.password,
    );

    String centerId;
    if (joinModel.centerUUID != null) {
      centerId = joinModel.centerUUID!;
    } else {
      DocumentReference newCenterRef =
          await _firestore.collection('centers').add({
        'name': joinModel.centerName,
      });
      centerId = newCenterRef.id;
    }

    await _firestore.collection('trainers').doc(userCredential.user!.uid).set({
      'email': joinModel.email,
      'name': joinModel.name,
      'phoneNumber': joinModel.phone,
      'center': centerId,
    });
  }
}
