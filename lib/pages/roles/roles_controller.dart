import 'package:flutter/material.dart';
import 'package:shoes/src/utils/shared_pref.dart';

import '../../src/models/user.dart';

class RolesController{

      BuildContext? context;
      Function? refresh;
      User? user;
      SharedPref sharedPref = new SharedPref();

      Future? init (BuildContext context, Function refresh) async {
          this.context = context;
          this.refresh = refresh;

          //WE GOT THE USER SESSION
          user = User.fromJson(await sharedPref.read('user'));
          refresh();
      }

      void goToPage(String route){
        Navigator.pushNamedAndRemoveUntil(context!, route, (route) => false);
      }
}