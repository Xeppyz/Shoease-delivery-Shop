import 'package:flutter/material.dart';
import 'package:shoes/src/utils/shared_pref.dart';


class ClienteProductsListController{

  BuildContext? context;
  SharedPref _sharedPref = new SharedPref();

  Future? init(BuildContext context){
    this.context = context;
  }

  logout(){
    _sharedPref.logout(context!);
  }
}