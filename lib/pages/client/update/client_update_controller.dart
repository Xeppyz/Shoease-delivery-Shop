import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shoes/src/models/response_api.dart';
import 'package:shoes/src/provider/users_provider.dart';
import 'package:shoes/src/utils/my_colors.dart';
import 'package:shoes/src/utils/my_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoes/src/utils/shared_pref.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../../src/models/user.dart';

class ClientUpdateController{

  BuildContext? context;

  TextEditingController nameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController numberController = new TextEditingController();


  UsersProvider usersProvider = new UsersProvider();

  PickedFile? pickedFile;
  File? imageFile;
  Function? refresh;

  ProgressDialog? _progressDialog;

  bool isEnable = true;
  User? user;
  SharedPref _sharedPref = new SharedPref();

  Future? init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _progressDialog = ProgressDialog(context: context);
    user = User.fromJson(await _sharedPref.read('user'));
    print("TOKEN ENVIADO ${user!.sessionToken}");
    usersProvider.init(context, sessionUser: user!);
   
    nameController.text = user!.name!;
    lastNameController.text = user!.lastname!;
    numberController.text = user!.phone!;

    refresh();
  }

  void goBack(){
    Navigator.pushNamed(context!, 'login');

  }

  void update() async {

    String name = nameController.text..trim();
    String lastName = lastNameController.text..trim();
    String number = numberController.text..trim();



    _progressDialog?.show(
        max: 100,
        msg: 'Espere un momento...',
        borderRadius: 10


    );
    isEnable = false;

    User myUser = new User(
        id: user?.id,
        name: name,
        lastname: lastName,
        phone: number,
        image: user?.image


    );

    Stream? stream = await usersProvider.update(myUser, imageFile!);
    stream?.listen((res)  async {

      _progressDialog?.close();
      // ResponseApi? responseApi = await usersProvider.create(user);
      ResponseApi? responseApi = ResponseApi.fromJson(json.decode(res));
      print('RESPUESTA: ${responseApi?.toJson()}');
      Fluttertoast.showToast(msg: responseApi.message!);

      if(responseApi!.success){
        user = await usersProvider.getById(myUser.id!); //getting user
        print('USUARIO OBTENIDO: ${user!.toJson()}');
        _sharedPref.save('user', user!.toJson());
        Navigator.pushNamedAndRemoveUntil(context!, 'client/products/list', (route) => false);

      }
      else{
        isEnable = true;
      }
    });

  }

  Future selectImage(ImageSource imageSource) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
    Navigator.pop(context!);
    refresh!();
  }


  void showAlertDialog(){
    Widget _galleryButton = ElevatedButton(
        onPressed: (){
          selectImage(ImageSource.gallery);
        },
        child: Text('GALERIA')
    );
    Widget _cameraButton = ElevatedButton(
        onPressed: (){
          selectImage(ImageSource.camera);
        },
        child: Text('CAMARA')
    );
    AlertDialog alertDialog = AlertDialog(
      title: Text('Selecciona tu imagen'),
      actions: [
        _galleryButton,
        _cameraButton
      ],
    );

    showDialog(
        context: context!,
        builder: (BuildContext? context){
          return alertDialog;
        }
    );
  }
}