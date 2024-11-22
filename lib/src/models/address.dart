// To parse this JSON data, do
//
//     final address = addressFromJson(jsonString);

import 'dart:convert';

AddressModel addressFromJson(String str) => AddressModel.fromJson(json.decode(str));

String addressToJson(AddressModel data) => json.encode(data.toJson());

class AddressModel {
  String? id;
  String? idUser;
  String? address;
  String? neighborhood;
  double? lat;
  double? lng;
  List<AddressModel> toList = [];

  AddressModel({
     this.id,
     this.idUser,
    required this.address,
    required this.neighborhood,
    required this.lat,
    required this.lng,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    id: json["id"] is int ? json["id"].toString() : json["id"],
    idUser: json["id_user"],
    address: json["address"],
    neighborhood: json["neighborhood"],
    lat: json["lat"] is String ? double.parse(json["lat"]) : json["lat"],
    lng: json["lng"] is String ? double.parse(json["lng"]) : json["lng"],
  );


  AddressModel.fromJsonList(List<dynamic> jsonList){
    if(jsonList == null) return;

    jsonList.forEach((item) {
      AddressModel addressModel = AddressModel.fromJson(item);
      toList.add(addressModel);
    });
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_user": idUser,
    "address": address,
    "neighborhood": neighborhood,
    "lat": lat,
    "lng": lng,
  };
}
