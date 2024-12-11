import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shoes/pages/business/categories/create/business_categories_create_page.dart';
import 'package:shoes/pages/business/orders/list/business_orders_list_page.dart';
import 'package:shoes/pages/business/products/create/business_products_create_page.dart';
import 'package:shoes/pages/client/address/create/client_address_create_page.dart';
import 'package:shoes/pages/client/address/list/client_address_list_page.dart';
import 'package:shoes/pages/client/address/map/client_address_map_page.dart';
import 'package:shoes/pages/client/orders/create/client_orders_create_page.dart';
import 'package:shoes/pages/client/orders/list/client_orders_list_page.dart';
import 'package:shoes/pages/client/orders/map/client_orders_map_page.dart';
import 'package:shoes/pages/client/payment/create/client_payment_create_page.dart';
import 'package:shoes/pages/client/payment/status/client_payments_status_page.dart';
import 'package:shoes/pages/client/products/list/client_products_list_controller.dart';
import 'package:shoes/pages/client/products/list/client_products_list_page.dart';
import 'package:shoes/pages/client/update/client_update_page.dart';
import 'package:shoes/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:shoes/pages/delivery/orders/map/delivery_orders_map_page.dart';
import 'package:shoes/pages/login/login_page.dart';
import 'package:shoes/pages/register/register_page.dart';
import 'package:shoes/pages/roles/roles_page.dart';
import 'package:shoes/src/provider/push_notifications_provider.dart';
import 'package:shoes/src/provider/stripe_provider.dart';
import 'package:shoes/src/utils/my_colors.dart';

// Instancia global del PushNotificationsProvider
PushNotificationsProvider pushNotificationsProvider = PushNotificationsProvider();

// Manejador de mensajes en segundo plano
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCujG7BT_9macCNULd67z4i_hF5jjjm_nA",
      appId: "1:385188939153:android:d6ec6629daf69405f9c630",
      messagingSenderId: "385188939153",
      projectId: "shoeaseapp",
    ),
  ); // Inicializa Firebase si usas otros servicios
  print('Mensaje recibido en segundo plano: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Inicialización requerida antes de Firebase
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCujG7BT_9macCNULd67z4i_hF5jjjm_nA",
      appId: "1:385188939153:android:d6ec6629daf69405f9c630",
      messagingSenderId: "385188939153",
      projectId: "shoeaseapp",
    ),
  ); // Inicializa Firebase
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler); // Configura el manejador de mensajes en segundo plano
  await pushNotificationsProvider.initNotifications(); // Inicializa notificaciones push
  runApp(MyApp()); // Arranca la app
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
        //'client/payments/create' : (BuildContext context) => ClientPaymentCreatePage(),
        'client/payments/status' : (BuildContext context) => ClientPaymentsStatusPage(),
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

