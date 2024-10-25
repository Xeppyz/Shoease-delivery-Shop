import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:shoes/src/api/environment.dart';
import 'package:shoes/src/models/category.dart';
import 'package:shoes/src/models/product.dart';
import 'package:shoes/src/utils/shared_pref.dart';

import '../models/response_api.dart';
import '../models/user.dart';

class ProductsProvider{
  String _url = Environment.API_SHOEASE;

  String _api = '/api/products';
  BuildContext? context;

  User? sessionUser;

  Future? init(BuildContext context, User sessionUser){
    this.context = context;
    this.sessionUser = sessionUser;
  }



  Future<Stream?> create(Product product, List<File> images) async{
    try{
      Uri uri = Uri.http(_url, '$_api/create');
      final request = http.MultipartRequest('POST',uri);
      request.headers['Authorization'] = sessionUser!.sessionToken!;

     for (int i = 0; i < images.length; i++){
       request.files.add(http.MultipartFile(
           'image',
           http.ByteStream(images[i].openRead().cast()),
           await images[i].length(),
           filename: basename(images[i].path)
       ));
     }
      request.fields['product'] = json.encode(product);
      final response = await request.send(); //SENT REQUEST NODE.JS
      return response.stream.transform(utf8.decoder);
    }catch(e){
      print("ERROR: ${e}");
      return null;
    }
  }



}