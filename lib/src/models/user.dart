// To parse this JSON data, do
// data of users
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String id;
  String name;
  String lastname;
  String email;
  String phone;
  String pw;
  String sessionToken;
  String image;

  User({
    required this.id,
    required this.name,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.pw,
    required this.sessionToken,
    required this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    lastname: json["lastname"],
    email: json["email"],
    phone: json["phone"],
    pw: json["pw"],
    sessionToken: json["session_token"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "lastname": lastname,
    "email": email,
    "phone": phone,
    "pw": pw,
    "session_token": sessionToken,
    "image": image,
  };
}
