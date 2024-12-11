
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shoes/src/models/order.dart';
import 'package:shoes/src/models/response_api.dart';
import 'package:shoes/src/provider/address_provider.dart';
import 'package:shoes/src/provider/orders_provider.dart';
import 'package:shoes/src/provider/stripe_provider.dart';
import 'package:shoes/src/utils/my_snackbar.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

import '../../../../src/models/address.dart';
import '../../../../src/models/product.dart';
import '../../../../src/models/user.dart';
import '../../../../src/utils/shared_pref.dart';

class ClientAddressListController{

  BuildContext? context;
  Function? refresh;
  List<AddressModel> address = [];
  User? user;
  SharedPref _sharedPref = new SharedPref();
  List<Product> selectedProduct = [];


  bool? isCreated;

  int radioValue = 0;
  AddressProvider _addressProvider = new AddressProvider();

  OrdersProvider _ordersProvider = new OrdersProvider();

  StripeProvider _stripeProvider = new StripeProvider();

  ProgressDialog? progressDialog;


  Future? init(BuildContext context, Function refresh) async {

    this.context = context;
    this.refresh = refresh;
    progressDialog = new ProgressDialog(context: context);
    user = User.fromJson(await _sharedPref.read('user'));

  _addressProvider.init(context, user!);
  _ordersProvider.init(context, user!);
  _stripeProvider.init();
    refresh();
  }

  void createOrder() async {
    try {
      const String amount = '5000'; // Monto en centavos
      const String currency = 'usd';

      // Inicializar el Payment Sheet y obtener el ID del PaymentIntent
      final paymentIntentId = await _stripeProvider.initializePaymentSheet(
        amount: amount,
        currency: currency,
      );

      // Presentar la hoja de pagos
      await _stripeProvider.presentPaymentSheet();

      // Si el pago es exitoso, crear la orden
      AddressModel address = AddressModel.fromJson(await _sharedPref.read('address') ?? {});
      selectedProduct = Product.fromJsonList(await _sharedPref.read('order')).toList;

      Order order = Order(
        idClient: user!.id!,
        idAddress: address.id!,
        products: selectedProduct,
      );

      ResponseApi? responseApi = await _ordersProvider.create(order);

      if (responseApi != null && responseApi.success == true) {
        print('Orden creada correctamente: ${responseApi.message}');

        // Navegar a la pantalla de estado de pago
        Navigator.pushNamed(
          context!,
          'client/payments/status',
          arguments: {
            'success': true,
            'paymentId': paymentIntentId, // ID del PaymentIntent
          },
        );
      } else {
        print('Error al crear la orden: ${responseApi?.message}');
        ScaffoldMessenger.of(context!).showSnackBar(
          SnackBar(content: Text('Error al crear la orden: ${responseApi?.message}')),
        );
      }
    } catch (e) {
      print('Error en el flujo de pago y creación de orden: $e');
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(content: Text('Ocurrió un error durante el proceso')),
      );

      // Navegar a la pantalla de estado de pago con fallo
      Navigator.pushNamed(
        context!,
        'client/payments/status',
        arguments: {
          'success': false,
          'paymentId': '',
        },
      );
    }
  }





  void handleRadioValueChange(int? value) async {
    radioValue = value!;
    _sharedPref.save('address', address[value]);


    refresh!();

    print("VALOR SELECCIONADO: ${radioValue}");
  }

  Future<List<AddressModel>> getAddress() async {
      address = await _addressProvider.getByUser(user!.id!);


      AddressModel a = AddressModel.fromJson(await _sharedPref.read('address') ?? {});
      int index = address.indexWhere((ad) => ad.id == a.id);
      if(index != -1){
        radioValue = index;
      }
      print("Se guardó la dirección: ${a.toJson()}");
      return address;
  }

  void goToNewAddres() async {
   var result = await Navigator.pushNamed(context!, 'client/address/create');

   if(result != null){
      if(result == true){
        refresh!();
      }
   }
  }

}