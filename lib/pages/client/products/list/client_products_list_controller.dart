import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoes/src/models/category.dart';
import 'package:shoes/src/provider/categories_provider.dart';
import 'package:shoes/src/utils/shared_pref.dart';

import '../../../../src/models/user.dart';


class ClienteProductsListController{

  BuildContext? context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Function? refresh;
  User? user;
  CategoriesProvider _categoriesProvider = new CategoriesProvider();
  List<Category> categories = [];



  Future? init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    _categoriesProvider.init(context, user!);
    getCategories();
    refresh();
  }

  void getCategories() async {
      categories = await _categoriesProvider.getAll();
      refresh!();

  }

  void logout(){
    _sharedPref.logout(context!, user!.id!);
  }

  void openDrawer(){
    key.currentState!.openDrawer();
  }

  void goToUpdateProfile(){
    Navigator.pushNamed(context!, 'client/update');
  }
  
  void goToRoles(){
    Navigator.pushNamedAndRemoveUntil(context!, 'roles', (route) => false);
  }
}