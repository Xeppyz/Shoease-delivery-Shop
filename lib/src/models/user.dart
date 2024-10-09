import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String? id;
  String? name;
  String? lastname;
  String? email;
  String? phone;
  String? pw;
  String? sessionToken;
  String? image;

  User({
    this.id,
    this.name,
    this.lastname,
    this.email,
    this.phone,
    this.pw,
    this.sessionToken,
    this.image,
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
