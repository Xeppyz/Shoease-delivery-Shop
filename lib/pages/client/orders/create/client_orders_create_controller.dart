import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shoes/src/models/product.dart';
import 'package:shoes/src/utils/shared_pref.dart';

class ClientOrdersCreateController{

  BuildContext? context;
  Function? refresh;
  Product? product;

  int counter = 1;
  double? productPrice;

  SharedPref _sharedPref = new SharedPref();
  List<Product> selectedProduct = [];
  double total = 0;

  Future? init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    selectedProduct = Product.fromJsonList(await _sharedPref.read('order')).toList;
    getTotal();

    refresh();
  }


  void getTotal(){
    total = 0;
    selectedProduct.forEach((product) {
      total = total + (product.quantity! * product!.price!);

    });

    refresh!();
  }

  void addItem(Product product){
    int index = selectedProduct.indexWhere((p) => p.id == product!.id!);
    selectedProduct[index].quantity = (selectedProduct[index].quantity! + 1)!;
    _sharedPref.save('order', selectedProduct);
    getTotal();


  }

  void removeItem(Product product){

    if(product.quantity! > 1){
      int index = selectedProduct.indexWhere((p) => p.id == product!.id!);
      selectedProduct[index].quantity = (selectedProduct[index].quantity! - 1)!;
      _sharedPref.save('order', selectedProduct);
      getTotal();
    }


  }

  void deleteItem(Product product){
      selectedProduct.removeWhere((p) => p.id == product.id);
      _sharedPref.save('order', selectedProduct);
      getTotal();
  }


  void goToAddress(){
    Navigator.pushNamed(context!, 'client/address/list');
    
  }



}