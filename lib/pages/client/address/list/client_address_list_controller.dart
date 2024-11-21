import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoes/src/models/order.dart';
import 'package:shoes/src/models/response_api.dart';
import 'package:shoes/src/provider/address_provider.dart';
import 'package:shoes/src/provider/orders_provider.dart';

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


  Future? init(BuildContext context, Function refresh) async {

    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));

  _addressProvider.init(context, user!);
  _ordersProvider.init(context, user!);
    refresh();
  }


  void createOrder() async {

    AddressModel a = AddressModel.fromJson(await _sharedPref.read('address') ?? {});
    selectedProduct = Product.fromJsonList(await _sharedPref.read('order')).toList;

    Order order = new Order(

        idClient: user!.id!,
        idAddress: a!.id!,
      products: selectedProduct


    );

    ResponseApi? responseApi = await _ordersProvider.create(order);

    print('Reespuesta orden: ${responseApi!.message} ');


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