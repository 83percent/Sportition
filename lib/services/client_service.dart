import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/clients/client_model.dart';

class ClientService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
