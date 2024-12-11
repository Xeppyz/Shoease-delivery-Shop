import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoes/src/models/response_api.dart';
import 'package:shoes/src/provider/push_notifications_provider.dart';
import 'package:shoes/src/provider/users_provider.dart';
import 'package:shoes/src/utils/my_snackbar.dart';
import 'package:shoes/src/utils/shared_pref.dart';

import '../../src/models/user.dart';

class LoginController{
  //NULL SAFETY
  BuildContext? context;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  UsersProvider usersProvider = new UsersProvider();
  SharedPref _sharedPref = new SharedPref();

  PushNotificationsProvider pushNotificationsProvider = PushNotificationsProvider();

  Future? init(BuildContext context) async{
    this.context = context;
    await usersProvider.init(context);

    User user = User.fromJson(await _sharedPref.read('user') ?? {});
    print('Usuario Obtenido: ${user.toJson()}');

    if(user?.sessionToken !=null){
      pushNotificationsProvider.saveToken(user, context!);
      if(user.roles!.length > 1) {
        //Eliminar el historial de pantallas anteriores navegadas
        Navigator.pushNamedAndRemoveUntil(context!, 'roles', (route) => false);
      }
      else{
        //Eliminar el historial de pantallas anteriores navegadas
        Navigator.pushNamedAndRemoveUntil(context!, user.roles![0].route!, (route) => false);
      }
    }

  }
  
  void goToRegisterPage(){
    Navigator.pushNamed(context!, 'register');
  }



  void login() async{
    String email = emailController.text.trim();
    String pw = passwordController.text.trim();
    
    ResponseApi? responseApi = await usersProvider.login(email, pw);
    print('Respuesta: ${responseApi?.toJson()}');
    if(responseApi!.success){
      User user = User.fromJson(responseApi.data);
      _sharedPref.save('user', user.toJson());
      pushNotificationsProvider.saveToken(user, context!);
      print('Usuarios logeado: ${user.toJson()}');
      if(user.roles!.length > 1) {
        //Eliminar el historial de pantallas anteriores navegadas
        Navigator.pushNamedAndRemoveUntil(context!, 'roles', (route) => false);
      }
      else{
        //Eliminar el historial de pantallas anteriores navegadas
        Navigator.pushNamedAndRemoveUntil(context!, user.roles![0].route!, (route) => false);
      }

    }
    else{
      MySnackBar.show(context!, responseApi?.message);
    }

  }

}