import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoes/src/api/environment.dart';
import 'package:shoes/src/models/user.dart';
import 'package:http/http.dart' as http;
import '../models/response_api.dart';

class UsersProvider {
  String _url = Environment.API_SHOEASE;
  String _api = '/api/users';

  BuildContext? context;

  Future? init(BuildContext context) {
    this.context = context;
  }

  Future<ResponseApi?> create(User user) async {
    try {
      Uri uri = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(user);
      print("URL $uri");

      Map<String, String> headers = {
        'Content-type': 'application/json'
      };
      final res = await http.post(uri, headers: headers, body: bodyParams);
      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
