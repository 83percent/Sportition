import 'dart:convert';

class ClientModel {
  final String uid;
  final String name;
  String? gender;

  ClientModel({
    required this.uid,
    required this.name,
    this.gender,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      uid: json['uid'],
      name: json['name'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'gender': gender,
    };
  }

  static String encode(List<ClientModel> clients) => json.encode(
        clients.map<Map<String, dynamic>>((client) => client.toJson()).toList(),
      );

  static List<ClientModel> decode(String clients) =>
      (json.decode(clients) as List<dynamic>)
          .map<ClientModel>((item) => ClientModel.fromJson(item))
          .toList();
}
