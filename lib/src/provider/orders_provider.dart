import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder_plus/geocoder.model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:shoes/src/api/environment.dart';
import 'package:shoes/src/models/address.dart';
import 'package:shoes/src/models/order.dart';
import 'package:shoes/src/utils/shared_pref.dart';

import '../models/response_api.dart';
import '../models/user.dart';

class OrdersProvider{
  String _url = Environment.API_SHOEASE;

  String _api = '/api/orders';
  BuildContext? context;

  User? sessionUser;

  Future? init(BuildContext context, User sessionUser){
        this.context = context;
        this.sessionUser = sessionUser;
  }


  Future<ResponseApi?> create(Order order) async {
    try {
      Uri uri = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(order);
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


  Future<ResponseApi?> updateToDispatched(Order order) async {
    try {
      Uri uri = Uri.http(_url, '$_api/updateToDispatched');
      String bodyParams = json.encode(order);
      print("URL $uri");

      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser!.sessionToken!
      };
      final res = await http.put(uri, headers: headers, body: bodyParams);
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

  Future<ResponseApi?> updateToOnTheWay(Order order) async {
    try {
      Uri uri = Uri.http(_url, '$_api/updateToOnTheWay');
      String bodyParams = json.encode(order);
      print("URL $uri");

      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser!.sessionToken!
      };
      final res = await http.put(uri, headers: headers, body: bodyParams);
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

  Future<ResponseApi?> updateToDelivered(Order order) async {
    try {
      Uri uri = Uri.http(_url, '$_api/updateToDelivered');
      String bodyParams = json.encode(order);
      print("URL $uri");

      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser!.sessionToken!
      };
      final res = await http.put(uri, headers: headers, body: bodyParams);
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

  Future<List<Order>> getByStatus(String status) async {
    try {
      Uri uri = Uri.http(_url, '$_api/findByStatus/$status');
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
      Order order = Order.fromJsonList(data);
      return order.toList;

    }catch(e){
      print("Error: ${e}");
      return [];
    }
  }


  Future<List<Order>> getDeliveryAndStatus(String idDelivery,String status) async {
    try {
      Uri uri = Uri.http(_url, '$_api/findByDeliveryAndStatus/$idDelivery/$status');
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
      Order order = Order.fromJsonList(data);
      return order.toList;

    }catch(e){
      print("Error: ${e}");
      return [];
    }
  }



  Future<List<Order>> getClientAndStatus(String idClient,String status) async {
    try {
      Uri uri = Uri.http(_url, '$_api/findByClientAndStatus/$idClient/$status');
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
      Order order = Order.fromJsonList(data);
      return order.toList;

    }catch(e){
      print("Error: ${e}");
      return [];
    }
  }






}