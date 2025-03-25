class JoinModel {
  String? centerUUID;
  String? centerName;
  String email;
  String password;
  String name;
  String phone;

  JoinModel({
    this.centerUUID,
    this.centerName,
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
  });
}
