import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoes/src/models/response_api.dart';
import 'package:shoes/src/provider/users_provider.dart';
import 'package:shoes/src/utils/my_colors.dart';
import 'package:shoes/src/utils/my_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import '../../src/models/user.dart';

class RegisterController{

  BuildContext? context;
  TextEditingController emailController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController numberController = new TextEditingController();
  TextEditingController pwController = new TextEditingController();
  TextEditingController pwConfirmController = new TextEditingController();

  UsersProvider usersProvider = new UsersProvider();

  PickedFile? pickedFile;
  File? imageFile;
  Function? refresh;

  ProgressDialog? _progressDialog;

  bool isEnable = true;

  Future? init(BuildContext context, Function refresh){
    this.context = context;
    this.refresh = refresh;

    usersProvider.init(context);
    _progressDialog = ProgressDialog(context: context);
  }

  void goBack(){
    Navigator.pushNamed(context!, 'login');

  }

  void register() async {
    String email = emailController.text..trim();
    String name = nameController.text..trim();
    String lastName = lastNameController.text..trim();
    String number = numberController.text..trim();
    String pw = pwController.text..trim();
    String pwConfirm = pwConfirmController.text..trim();


    if (email.isEmpty || name.isEmpty || lastName.isEmpty || number.isEmpty ||
        number.isEmpty || pw.isEmpty || pwConfirm.isEmpty) {
      MySnackBar.show(context!, 'Debes ingresar todos los campos');
      return;
    }

    if (pwConfirm != pw) {
      MySnackBar.show(context!, 'Las contraseñas no coinciden');
      return;
    }

    if (pw.length < 6) {
      MySnackBar.show(
          context!, 'La contraseña debe de tener al menos 6 digitos');
      return;
    }

    if(imageFile == null){
      MySnackBar.show(context!, 'Selecciona una imagen');
      return;
    }

    _progressDialog?.show(
      max: 100,
      msg: 'Espere un momento...',
      borderRadius: 10


    );
    isEnable = false;



    User user = new User(
        email: email,
        name: name,
        lastname: lastName,
        phone: number,
        pw: pw
    );

    Stream? stream = await usersProvider.createWithImage(user, imageFile!);
    stream?.listen((res)  {
      
      _progressDialog?.close();
     // ResponseApi? responseApi = await usersProvider.create(user);
      ResponseApi? responseApi = ResponseApi.fromJson(json.decode(res));
      print('RESPUESTA: ${responseApi?.toJson()}');
      MySnackBar.show(context!, responseApi?.message);

      if(responseApi!.success){
        Future.delayed(Duration(seconds: 3),(){
          Navigator.pushReplacementNamed(context!, 'login');
        });
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