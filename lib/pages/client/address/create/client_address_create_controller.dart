import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../map/client_address_map_page.dart';

class ClientAddressCreateController{

  BuildContext? context;
  Function? refresh;

  Future? init(BuildContext context, Function refresh){

    this.context = context;
    this.refresh = refresh;


  }

  void openMap(){
    showMaterialModalBottomSheet(
        context: context!,
        isDismissible: false,
        enableDrag: false,
        builder: (context) => ClientAddressMapPage()
    );
  }

}