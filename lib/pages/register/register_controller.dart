import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoes/src/models/response_api.dart';
import 'package:shoes/src/provider/users_provider.dart';
import 'package:shoes/src/utils/my_snackbar.dart';

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

  Future? init(BuildContext context){
    this.context = context;
    usersProvider.init(context);
  }

  void goBack(){
    Navigator.pushNamed(context!, 'login');

  }

  void register() async{
    String email = emailController.text..trim();
    String name = nameController.text..trim();
    String lastName = lastNameController.text..trim();
    String number = numberController.text..trim();
    String pw = pwController.text..trim();
    String pwConfirm = pwConfirmController.text..trim();


    if(email.isEmpty || name.isEmpty || lastName.isEmpty || number.isEmpty || number.isEmpty || pw.isEmpty || pwConfirm.isEmpty){
      MySnackBar.show(context!, 'Debes ingresar todos los campos');
      return;
    }

    if(pwConfirm != pw){
      MySnackBar.show(context!, 'Las contraseñas no coinciden');
      return;
    }

    if(pw.length < 6){
      MySnackBar.show(context!, 'La contraseña debe de tener al menos 6 digitos');
      return;
    }
    User user = new User(
      email: email,
      name: name,
      lastname: lastName,
      phone: number,
      pw: pw
    );

    ResponseApi? responseApi = await usersProvider.create(user);

    MySnackBar.show(context!, responseApi?.message);

    print('RESPUESTA: ${responseApi?.toJson()}');
    print("Email ${email}");
    print("Name ${name}");
    print("Name ${lastName}");
    print("Name ${number}");
    print("Name ${pwConfirm}");
    print("pw ${pw}");
  }
}