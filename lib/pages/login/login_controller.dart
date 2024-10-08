import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginController{
  //NULL SAFETY
  BuildContext? context;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  Future? init(BuildContext context){
    this.context = context;

  }
  
  void goToRegisterPage(){
    Navigator.pushNamed(context!, 'register');
  }

  void login(){
    String email = emailController.text.trim();
    String pw = passwordController.text.trim();

    print("Email ${email}");
    print("Email ${pw}");
  }

}