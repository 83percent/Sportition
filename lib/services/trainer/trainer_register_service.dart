import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sportition_center/models/join/join_dto.dart';

class TrainerRegisterService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// This method is used to register a trainer
  /// 트레이너를 Firestore에 등록한다.
  Future<void> registerTrainer(JoinDTO joinDTO) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: joinDTO.email!,
        password: joinDTO.password!,
      );

      await _firestore
          .collection('trainers')
          .doc(userCredential.user!.uid)
          .set({
        'email': joinDTO.email,
        'name': joinDTO.name,
        'centerUID': joinDTO.centerUID,
        'regDttm': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to register trainer');
    }
  }
}
