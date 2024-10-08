import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoes/src/api/environment.dart';

class UsersProvider{

  String _url = Environment.API_SHOEASE;

  String _api = '/api/users/';

  BuildContext? context;

  Future? init(BuildContext context){
    this.context = context;
  }

  //Future<>

}