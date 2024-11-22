import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder_plus/geocoder.model.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shoes/src/models/response_api.dart';
import 'package:shoes/src/provider/address_provider.dart';
import 'package:shoes/src/utils/my_snackbar.dart';
import 'package:shoes/src/utils/shared_pref.dart';

import '../../../../src/models/user.dart';
import 'package:shoes/src/models/address.dart';

import '../map/client_address_map_page.dart';

class ClientAddressCreateController{

  BuildContext? context;
  Function? refresh;
  User? user;
  SharedPref _sharedPref = new SharedPref();

  TextEditingController refPointController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController neighborhoodController = new TextEditingController();
  Map<String, dynamic>? refPoint;

  AddressProvider _addressProvider = new AddressProvider();

  Future? init(BuildContext context, Function refresh) async {

    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    
    _addressProvider.init(context, user!);


  }

  void openMap() async {
    refPoint = await showMaterialModalBottomSheet(
        context: context!,
        isDismissible: false,
        enableDrag: false,
        builder: (context) => ClientAddressMapPage()
    );

    if(refPoint != null){
      refPointController.text = refPoint!['address'];
      refresh!();
    }
  }

  void createAddress() async {
    String address = addressController.text;
    String neigborhood = neighborhoodController.text;

    double lat = refPoint?['lat'] ?? 0;
    double lng = refPoint?['lng'] ?? 0;

    if(address.isEmpty || neigborhood.isEmpty || lat == 0 || lng == 0){
      MySnackBar.show(context!, 'Completa los campos');
      return;
    }

    AddressModel addressModel = new AddressModel(
      address: address,
      neighborhood: neigborhood,
      lat: lat,
      lng: lng,
      idUser: user!.id

    );

    ResponseApi? responseApi = await _addressProvider.create(addressModel);

    if(responseApi!.success){

      //ESTO NO SIRVE DEBERIA DE HACER QUE AL CREAR NUEVA ADDRESS EL RADIOBUTTON VALUE TOME LA NUEVA DIRECCIÓON
      addressModel.id == responseApi.data;
      _sharedPref.save('address', addressModel);

      Fluttertoast.showToast(msg: 'Dirección guadada con éxito');
      Navigator.pop(context!, true);
    }

  }


}