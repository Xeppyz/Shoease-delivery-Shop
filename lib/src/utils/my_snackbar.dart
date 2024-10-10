import  'package:flutter/material.dart';

class MySnackBar{

  static void show(BuildContext context, String? text){
    if(context == null) return;

    FocusScope.of(context).requestFocus(new FocusNode());

    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
        new SnackBar(
            content: Text(
              text!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
          backgroundColor: Colors.black26,
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(top: 50.0, left: 10.0, right: 10.0),



        )
    );
  }

}