class JoinModel {
  String userType;
  String? centerUUID;
  String? centerName;
  String email;
  String password;
  String name;
  String phone;

  JoinModel({
    required this.userType,
    this.centerUUID,
    this.centerName,
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
  });

  // JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'centerUUID': centerUUID,
      'centerName': centerName,
      'email': email,
      'password': password,
      'name': name,
      'phone': phone,
    };
  }

  // JSON 역직렬화
  factory JoinModel.fromJson(Map<String, dynamic> json) {
    return JoinModel(
      userType: json['userType'],
      centerUUID: json['centerUUID'],
      centerName: json['centerName'],
      email: json['email'],
      password: json['password'],
      name: json['name'],
      phone: json['phone'],
    );
  }
}
