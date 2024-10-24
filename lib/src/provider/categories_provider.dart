import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:shoes/src/api/environment.dart';
import 'package:shoes/src/models/category.dart';
import 'package:shoes/src/utils/shared_pref.dart';

import '../models/response_api.dart';
import '../models/user.dart';

class CategoriesProvider{
  String _url = Environment.API_SHOEASE;

  String _api = '/api/categories';
  BuildContext? context;

  User? sessionUser;

  Future? init(BuildContext context, User sessionUser){
        this.context = context;
        this.sessionUser = sessionUser;
  }


  Future<ResponseApi?> create(Category category) async {
    try {
      Uri uri = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(category);
      print("URL $uri");

      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser!.sessionToken!
      };
      final res = await http.post(uri, headers: headers, body: bodyParams);
      if(res.statusCode == 401){
        Fluttertoast.showToast(msg: 'Sesión expirada');
        new SharedPref().logout(context!, sessionUser!.id!);
      }
      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<List<Category>> getAll() async {
    try {
      Uri uri = Uri.http(_url, '$_api/getAll');
      print("URL $uri");

      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser!.sessionToken!
      };


      final res = await http.get(uri, headers: headers);
      if(res.statusCode == 401){
        Fluttertoast.showToast(msg: 'Sesión expirada');
        new SharedPref().logout(context!, sessionUser!.id!);
      }
      final data = json.decode(res.body); //CATEGORIES
      Category category = Category.fromJsonList(data);
      return category.toList;

    }catch(e){
      print("Error: ${e}");
      return [];
    }
  }

}