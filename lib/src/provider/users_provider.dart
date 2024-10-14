import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoes/src/api/environment.dart';
import 'package:shoes/src/models/user.dart';
import 'package:http/http.dart' as http;
import '../models/response_api.dart';
import 'package:path/path.dart';

class UsersProvider {
  String _url = Environment.API_SHOEASE;
  String _api = '/api/users';

  BuildContext? context;

  Future? init(BuildContext context) {
    this.context = context;
  }


  Future<User?> getById (String id) async {
    try{
      Uri uri = Uri.http(_url, '$_api/findById/$id');
      Map<String, String> headers = {
        'Content-type': 'application/json'
      };
      final res = await http.get(uri, headers: headers);
      final data = json.decode(res.body);
      User user = User.fromJson(data);
      return user;

    }catch(e){
      print('Error: ${e}');
      return null;
    }
  }

  Future<Stream?> createWithImage(User user, File image) async{
        try{
          Uri uri = Uri.http(_url, '$_api/create');
          final request = http.MultipartRequest('POST',uri);

          if (image != null){
            request.files.add(http.MultipartFile(
              'image',
              http.ByteStream(image.openRead().cast()),
              await image.length(),
              filename: basename(image.path)
            ));
          }
          request.fields['user'] = json.encode(user);
          final response = await request.send(); //SENT REQUEST NODE.JS
          return response.stream.transform(utf8.decoder);
        }catch(e){
          print("ERROR: ${e}");
          return null;
        }
  }

  Future<Stream?> update(User user, File image) async{
    try{
      Uri uri = Uri.http(_url, '$_api/update');
      final request = http.MultipartRequest('PUT',uri);

      if (image != null){
        request.files.add(http.MultipartFile(
            'image',
            http.ByteStream(image.openRead().cast()),
            await image.length(),
            filename: basename(image.path)
        ));
      }
      request.fields['user'] = json.encode(user);
      final response = await request.send(); //SENT REQUEST NODE.JS
      return response.stream.transform(utf8.decoder);
    }catch(e){
      print("ERROR: ${e}");
      return null;
    }
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

  Future<ResponseApi?> login (String email, String pw) async {
    try {
      Uri uri = Uri.http(_url, '$_api/login');
      String bodyParams = json.encode({
        'email': email,
        'pw': pw
      });
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
