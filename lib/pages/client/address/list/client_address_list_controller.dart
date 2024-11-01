import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClientAddressListController{

  BuildContext? context;
  Function? refresh;

  Future? init(BuildContext context, Function refresh){

    this.context = context;
    this.refresh = refresh;

    return null;
  }

  void goToNewAddres(){
    Navigator.pushNamed(context!, 'client/address/create');
  }

}