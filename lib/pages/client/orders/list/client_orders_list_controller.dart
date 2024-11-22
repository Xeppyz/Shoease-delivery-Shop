import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shoes/pages/business/orders/detail/business_orders_detail_page.dart';
import 'package:shoes/pages/delivery/orders/detail/delivery_orders_detail_page.dart';
import 'package:shoes/src/models/order.dart';
import 'package:shoes/src/provider/orders_provider.dart';
import 'package:shoes/src/utils/shared_pref.dart';

import '../../../../src/models/user.dart';
import '../detail/client_orders_detail_page.dart';


class ClientOrdersListController{

  BuildContext? context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Function? refresh;
  User? user;


  List<String> status = ['PAGADO','EMPACADO', 'EN CAMINO', 'ENTREGADO'];

  OrdersProvider _ordersProvider = new OrdersProvider();
  bool? isUpdated;

  Future? init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    _ordersProvider.init(context, user!);
    refresh();
  }



  void openBottomSheet(Order order) async {
    if (context != null) {
      isUpdated = await showMaterialModalBottomSheet(
        context: context!,
        builder: (context) => ClientOrdersDetailPage(order: order),
      );
      if(isUpdated == true){
        refresh!();
      }
    } else {
      print('Contexto es nulo');
    }
  }


  Future<List<Order>> getOrders (String status) async {
    return await _ordersProvider.getClientAndStatus(user!.id!,status);
  }

  void logout(){
    _sharedPref.logout(context!, user!.id!);
  }

  void goToCategeoryCreate(){
    Navigator.pushNamed(context!, 'business/categories/create');
  }

  void goToProductsCreate(){
    Navigator.pushNamed(context!, 'business/products/create');
  }


  void openDrawer(){
    key.currentState!.openDrawer();
  }
  void goToRoles(){
    Navigator.pushNamedAndRemoveUntil(context!, 'roles', (route) => false);
  }
}