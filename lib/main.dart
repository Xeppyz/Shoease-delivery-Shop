import 'package:flutter/material.dart';
import 'package:shoes/pages/business/categories/create/business_categories_create_page.dart';
import 'package:shoes/pages/business/orders/list/business_orders_list_page.dart';
import 'package:shoes/pages/business/products/create/business_products_create_page.dart';
import 'package:shoes/pages/client/address/create/client_address_create_page.dart';
import 'package:shoes/pages/client/address/list/client_address_list_page.dart';
import 'package:shoes/pages/client/address/map/client_address_map_page.dart';
import 'package:shoes/pages/client/orders/create/client_orders_create_page.dart';
import 'package:shoes/pages/client/orders/list/client_orders_list_page.dart';
import 'package:shoes/pages/client/orders/map/client_orders_map_page.dart';
import 'package:shoes/pages/client/products/list/client_products_list_controller.dart';
import 'package:shoes/pages/client/products/list/client_products_list_page.dart';
import 'package:shoes/pages/client/update/client_update_page.dart';
import 'package:shoes/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:shoes/pages/delivery/orders/map/delivery_orders_map_page.dart';
import 'package:shoes/pages/login/login_page.dart';
import 'package:shoes/pages/register/register_page.dart';
import 'package:shoes/pages/roles/roles_page.dart';
import 'package:shoes/src/utils/my_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shoease',
      initialRoute: 'login',
      routes: {
        'login' : (BuildContext context) => LoginPage(),
        'register' : (BuildContext context) => RegisterPage(),
        'roles' : (BuildContext context) => RolesPage(),
        'client/products/list' : (BuildContext context) => ClienteProductsListPage(),
        'client/update' : (BuildContext context) => ClientUpdatePage(),
        'client/orders/create' : (BuildContext context) => ClientOrdersCreatePage(),
        'client/address/list' : (BuildContext context) => ClientAddressListPage(),
        'client/address/create' : (BuildContext context) => ClientAddressCreatePage(),
        'client/address/map' : (BuildContext context) => ClientAddressMapPage(),
        'client/orders/list' : (BuildContext context) => ClientOrdersListPage(),
        'client/orders/map' : (BuildContext context) => ClientOrdersMapPage(),
        'business/orders/list' : (BuildContext context) => BusinessOrdersListPage(),
        'business/categories/create' : (BuildContext context) => BusinessCategoriesCreatePage(),
        'business/products/create' : (BuildContext context) => BusinessProductsCreatePage(),
        'delivery/orders/list' : (BuildContext context) => DeliveryOrdersListPage(),
        'delivery/orders/map' : (BuildContext context) => DeliveryOrdersMapPage(),


      },
      theme: ThemeData(
        primaryColor: MyColors.primaryColor,
        appBarTheme: AppBarTheme(
          elevation: 0.0
        ),
      ),

    );
  }
}

