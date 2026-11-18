import 'dart:convert';

class User {
  int? user_id;
  String user_fullname;
  String user_email;
  String user_password;
  String user_birthdate;
  String user_gender;
  String user_address;
  String user_phone;
  User({
    this.user_id,
    required this.user_fullname,
    required this.user_email,
    required this.user_password,
    required this.user_birthdate,
    required this.user_gender,
    required this.user_address,
    required this.user_phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'user_fullname': user_fullname,
      'user_email': user_email,
      'user_password': user_password,
      'user_birthdate': user_birthdate,
      'user_gender': user_gender,
      'user_address': user_address,
      'user_phone': user_phone,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      user_id: map['user_id']?.toInt(),
      user_fullname: map['user_fullname'] ?? '',
      user_email: map['user_email'] ?? '',
      user_password: map['user_password'] ?? '',
      user_birthdate: map['user_birthdate'] ?? '',
      user_gender: map['user_gender'] ?? '',
      user_address: map['user_address'] ?? '',
      user_phone: map['user_phone'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
