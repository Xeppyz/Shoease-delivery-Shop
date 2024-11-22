import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoes/pages/client/products/detail/client_products_detail_page.dart';
import 'package:shoes/src/models/category.dart';
import 'package:shoes/src/provider/categories_provider.dart';
import 'package:shoes/src/provider/products_provider.dart';
import 'package:shoes/src/utils/shared_pref.dart';

import '../../../../src/models/product.dart';
import '../../../../src/models/user.dart';


class ClienteProductsListController{

  BuildContext? context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Function? refresh;
  User? user;
  CategoriesProvider _categoriesProvider = new CategoriesProvider();
  ProductsProvider _productsProvider = new ProductsProvider();
  List<Category> categories = [];



  Future? init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    _categoriesProvider.init(context, user!);
    getCategories();
    _productsProvider.init(context, user!);
    refresh();
  }


  Future<List<Product>> getProducts (String idCategory) async {
      return await _productsProvider.getByCategory(idCategory);
  }

  void getCategories() async {
      categories = await _categoriesProvider.getAll();
      refresh!();

  }

  void openBottomSheet(Product product){
    showMaterialModalBottomSheet(

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10.0)
          )
        ),
        context: context!,
        builder: (context) => ClientProductsDetailPage(product: product,)
    );
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

  void goToOrdersList(){
    Navigator.pushNamed(context!, 'client/orders/list');
  }


  void goToOrderCreatePage(){
    Navigator.pushNamed(context!, 'client/orders/create');
  }
  
  void goToRoles(){
    Navigator.pushNamedAndRemoveUntil(context!, 'roles', (route) => false);
  }
}