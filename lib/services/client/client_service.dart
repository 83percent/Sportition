import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportition_center/models/clients/client_dto.dart';
import '../../models/clients/client_model.dart';

class ClientService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger('ClientService');

  // Singleton
  static final ClientService _clientService = ClientService._internal();
  ClientService._internal();
  factory ClientService() {
    return _clientService;
  }

  Future<List<ClientDTO>> getClientDTOList() async {
    List<ClientDTO> clientUIDList = [];
    String? trainerUID;
    String? centerUID;

    // Step 1: Get CenterUID
    SharedPreferences prefs = await SharedPreferences.getInstance();
    trainerUID = prefs.getString('trainerUID');
    centerUID = prefs.getString('centerUID');

    if (centerUID == null || centerUID.isEmpty) {
      // Step 1-1: firestore에서 trainerUID 가져오기
      DocumentSnapshot trainerDoc =
          await _firestore.collection('trainers').doc(trainerUID).get();
      centerUID = trainerDoc.get('centerUID');
    }

    if (centerUID == null || centerUID.isEmpty) {
      throw Exception('센터 정보를 조회하는 과정에서 오류가 발생하였습니다.');
    }

    // Step 2: Get clients subcollection from centers/{centerUID}/clients
    QuerySnapshot clientDocs = await _firestore
        .collection('centers')
        .doc(centerUID)
        .collection('clients')
        .get();
    // TODO : clients doc이 없는 경우 어떤 오류를 반환하는가?

    // Step 3: Map documents to ClientDTO list

    return clientUIDList;
  }

  Future<List<ClientModel>> getClients(String uid) async {
    List<ClientModel> clients = [];

    // Step 2: Get clients array from shardPreferences collection
    DocumentSnapshot centerDoc =
        await _firestore.collection('centers').doc(uid).get();

    if (!centerDoc.exists) {
      return clients;
    }

    final data = centerDoc.data() as Map<String, dynamic>;

    if (!data.containsKey('clients')) {
      return clients;
    }

    List<dynamic> clientList = centerDoc['clients'];

    // Step 3: Get client details from clients array
    for (var client in clientList) {
      clients.add(ClientModel(
        uid: client['uid'] ?? '',
        name: client['name'] ?? 'Unknown',
        gender: client['gender'] ?? '',
      ));
    }

    // Step 4: Return client_model list
    return clients;
  }
}
