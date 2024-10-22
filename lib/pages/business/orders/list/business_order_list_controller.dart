import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shoes/src/utils/shared_pref.dart';

import '../../../../src/models/user.dart';


class BusinnesOrderListController{

  BuildContext? context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Function? refresh;
  User? user;

  Future? init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    refresh();
  }

  void logout(){
    _sharedPref.logout(context!, user!.id!);
  }

  void goToCategeoryCreate(){
    Navigator.pushNamed(context!, 'business/categories/create');
  }

  void openDrawer(){
    key.currentState!.openDrawer();
  }
  void goToRoles(){
    Navigator.pushNamedAndRemoveUntil(context!, 'roles', (route) => false);
  }
}