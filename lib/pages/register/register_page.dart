import 'package:flutter/cupertino.dart';
import  'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shoes/pages/register/register_controller.dart';

import '../../src/utils/my_colors.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  RegisterController _con = new RegisterController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      width: double.infinity,
        child: Stack(
          children: [
            Positioned(
                top: -80,
                left: -100,
                child: _circleLogin()
            ),
            Positioned(
                top: 70.0,
                left: 20.0,
                child: _textLogin()
            ),
            Positioned(
                top: 59.0,
                left: -5.0,
                child: _iconBack()
            ),

            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 150.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _imageUser(),
                    SizedBox(height: 30.0,),
                    _textFieldEmail(),
                    _textFieldName(),
                    _textFieldLastName(),
                    _textFieldNumber(),
                    _textFieldPass(),
                    _textFieldPassAgain(),
                    _buttonLogin()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _imageUser(){
    return CircleAvatar(
      backgroundImage: AssetImage('assets/img/user_profile_2.png'),
      radius: 60,
      backgroundColor: Colors.grey[400],
    );
  }

  Widget _circleLogin(){
    return Container(
      width: 240.0,
      height: 230.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: MyColors.primaryColor
      ),
    );
  }

  Widget _textFieldEmail(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(50.0)
      ),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        controller: _con.emailController,
        decoration:InputDecoration(
            hintText: 'Email',
            hintStyle: TextStyle(
                color: MyColors.primaryDark
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15.0),
            prefixIcon: Icon(
              Icons.email,
              color: MyColors.primaryColor,
            )
        ) ,
      ),
    );
  }
  Widget _textFieldName(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(50.0)
      ),
      child: TextField(
        controller: _con.nameController,
        decoration:InputDecoration(
            hintText: 'Nombre',
            hintStyle: TextStyle(
                color: MyColors.primaryDark
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15.0),
            prefixIcon: Icon(
              Icons.person,
              color: MyColors.primaryColor,
            )
        ) ,
      ),
    );
  }
  Widget _textFieldLastName(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(50.0)
      ),
      child: TextField(
        controller: _con.lastNameController,
        decoration:InputDecoration(
            hintText: 'Apellido',
            hintStyle: TextStyle(
                color: MyColors.primaryDark
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15.0),
            prefixIcon: Icon(
              Icons.drive_file_rename_outline_rounded,
              color: MyColors.primaryColor,
            )
        ) ,
      ),
    );
  }
  Widget _textFieldNumber(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(50.0)
      ),
      child: TextField(
        controller: _con.numberController,
        keyboardType: TextInputType.number,
        decoration:InputDecoration(
            hintText: 'Teléfono',
            hintStyle: TextStyle(
                color: MyColors.primaryDark
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15.0),
            prefixIcon: Icon(
              Icons.phone_forwarded,
              color: MyColors.primaryColor,
            )
        ) ,
      ),
    );
  }
  Widget _textFieldPass(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(50.0)
      ),
      child: TextField(
        controller: _con.pwController,
        obscureText: true,
        decoration:InputDecoration(
            hintText: 'Contraseña',
            hintStyle: TextStyle(
                color: MyColors.primaryDark
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15.0),
            prefixIcon: Icon(
              Icons.lock,
              color: MyColors.primaryColor,
            )
        ) ,
      ),
    );
  }
  Widget _textFieldPassAgain(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(50.0)
      ),
      child: TextField(
        controller: _con.pwConfirmController,
        obscureText: true,
        decoration:InputDecoration(
            hintText: 'Confirmar Contraseña',
            hintStyle: TextStyle(
                color: MyColors.primaryDark
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15.0),
            prefixIcon: Icon(
              Icons.lock_clock,
              color: MyColors.primaryColor,
            )
        ) ,
      ),
    );
  }
  Widget _buttonLogin(){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
      child: ElevatedButton(
        onPressed: _con.register,
        child: Text(
          'Ingresar',
          style: TextStyle(
              color: MyColors.primaryDark
          ),
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: EdgeInsets.symmetric(vertical: 15)
        ),
      ),
    );
  }
  Widget _iconBack(){
    return IconButton(
        onPressed: _con.goBack,
        icon: Icon(Icons.arrow_back_ios,));
  }
  Widget _textLogin(){
    return Text(
      'REGISTER',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
        fontFamily: 'NimbusSans',
      ),
    );
  }
}
