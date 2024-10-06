import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoes/src/utils/my_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            _imageBanner(),
            _textFieldEmail(),
            _textFieldPass(),
            _buttonLogin(),
            _textFielDontHaveAccount()


          ],
        ),
      )
    );
  }


  Widget _textFielDontHaveAccount(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('¿No tienes cuenta?'),
        SizedBox(width: 7.0,),
        Text(
          'Registrate',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            // color: MyColors.primaryColor
          ),
        )
      ],
    );
  }

  Widget _imageBanner(){
    return Image.asset('assets/img/DeliverySho.png',
        width: 200.0,
        height: 200.0
    );

  }

  Widget _textFieldEmail(){
    return TextField(
      decoration:InputDecoration(
          hintText: 'Email'
      ) ,
    );
  }

  Widget _textFieldPass(){
    return TextField(
      decoration:InputDecoration(
          hintText: 'Contraseña'
      ) ,
    );
  }

  Widget _buttonLogin(){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
      child: ElevatedButton(
          onPressed: (){
          },
          child: Text(
              'Ingresar',
            style: TextStyle(
              color: Colors.black
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
