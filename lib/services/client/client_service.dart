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
    List<ClientDTO> clientDTOList = [];
    String? centerUID;

    // Step 1: Get CenterUID
    SharedPreferences prefs = await SharedPreferences.getInstance();
    centerUID = prefs.getString('centerUID');

    // Step 2: firestore에서 회원 정보 갖고오기
    // centers/{centerUID}/clients 전부 갖고와서 clientDTOList에 넣기
    if (centerUID == null || centerUID.isEmpty) {
      _logger.warning('CenterUID is null or empty');
      return clientDTOList;
    }

    try {
      QuerySnapshot clientsSnapshot = await _firestore
          .collection('centers')
          .doc(centerUID)
          .collection('clients')
          .get();

      for (var doc in clientsSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        ClientDTO clientDTO = ClientDTO(
          clientUID: doc.id,
          name: data['clientName'] ?? 'Unknown',
          gender: data['gender'] ?? 'unset',
        );

        clientDTOList.add(clientDTO);
      }
    } catch (e) {
      _logger.severe('Failed to fetch clients: $e');
    }

    return clientDTOList;
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
