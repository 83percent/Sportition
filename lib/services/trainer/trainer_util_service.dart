import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrainerUtilService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final TrainerUtilService _trainerUtilService =
      TrainerUtilService._internal();
  TrainerUtilService._internal();
  factory TrainerUtilService() {
    return _trainerUtilService;
  }

  Future<String?> getTrainerUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('trainerUID');
  }
}
