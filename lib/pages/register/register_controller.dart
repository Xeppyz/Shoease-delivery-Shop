import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterController{

  BuildContext? context;
  TextEditingController emailController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController numberController = new TextEditingController();
  TextEditingController pwController = new TextEditingController();
  TextEditingController pwConfirmController = new TextEditingController();

  Future? init(BuildContext context){
    this.context = context;
  }

  void goBack(){
    Navigator.pushNamed(context!, 'login');

  }

  void register(){
    String email = emailController.text..trim();
    String name = nameController.text..trim();
    String lastName = lastNameController.text..trim();
    String number = numberController.text..trim();
    String pw = pwController.text..trim();
    String pwConfirm = pwConfirmController.text..trim();

    print("Email ${email}");
    print("Name ${name}");
    print("Name ${lastName}");
    print("Name ${number}");
    print("Name ${pwConfirm}");
    print("pw ${pw}");
  }
}