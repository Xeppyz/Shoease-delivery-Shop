import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:shoes/src/utils/my_colors.dart';

import 'login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {

  LoginController _con = new LoginController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //Con esto evitamos que nos salte el null operator del controlador
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(

        child: Container(
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                  top: -80,
                  left: -100,
                  child: _circleLogin()
              ),
              Positioned(
                  top: 60.0,
                  left: 25.0,
                  child: _textLogin()
              ),
              Column(
                children: [
                  _lottiAnimation(),
                  //_imageBanner(),
                  _textFieldEmail(),
                  _textFieldPass(),
                  _buttonLogin(),
                  _textFielDontHaveAccount()


                ],
              ),
            ],
          ),
        ),
      )
    );
  }


  Widget _textLogin(){
    return Text(
      'LOGIN',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 25.0,
        fontFamily: 'NimbusSans',

      ),
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

  Widget _textFielDontHaveAccount(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('¿No tienes cuenta?'),
        SizedBox(width: 7.0,),
        GestureDetector(
          onTap: _con.goToRegisterPage,
          child: Text(
            'Registrate',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              // color: MyColors.primaryColor
            ),
          ),
        )
      ],
    );
  }

  Widget _lottiAnimation(){
    final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(
          top: 150,
          bottom: screenHeight * 0.17
      ),
      child: Lottie.asset(
          'assets/json/delivery.json',
          width:  350,
          height: 200,
        fit: BoxFit.fill
      ),
    );
  }

  //This widget was used before
  Widget _imageBanner(){
    final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(
          top: 100,
          bottom: screenHeight * 0.20
      ),
      child: Image.asset('assets/img/DeliverySho.png',
          width: 200.0,
          height: 200.0
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
        controller: _con.emailController,
        keyboardType: TextInputType.emailAddress,
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

  Widget _textFieldPass(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(50.0)
      ),
      child: TextField(
        controller: _con.passwordController,
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

  Widget _buttonLogin(){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
      child: ElevatedButton(
          onPressed: _con.login,
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
}
