import 'dart:convert';

import 'package:shoes/src/models/rol.dart';

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
  String? notificationToken;
  String? image;
  List<Rol>? roles = [];
  List<User> toList = [];

  User({
    this.id,
    this.name,
    this.lastname,
    this.email,
    this.phone,
    this.pw,
    this.sessionToken,
    this.notificationToken,
    this.image,
    this.roles
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] is int ? json["id"].toString() : json["id"],
    name: json["name"],
    lastname: json["lastname"],
    email: json["email"],
    phone: json["phone"],
    pw: json["pw"],
    sessionToken: json["session_token"],
    notificationToken: json["notification_token"],
    image: json["image"],
    roles: json["roles"] == null ? [] : List<Rol>.from(json['roles'].map((model) => Rol.fromJson(model))) ?? [],
  );


  User.fromJsonList(List<dynamic> jsonList){
    if(jsonList == null) return;

    jsonList.forEach((item) {
      User category = User.fromJson(item);
      toList.add(category);
    });
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "lastname": lastname,
    "email": email,
    "phone": phone,
    "pw": pw,
    "session_token": sessionToken,
    "notification_token": notificationToken,
    "image": image,
    "roles": roles,
  };
}
