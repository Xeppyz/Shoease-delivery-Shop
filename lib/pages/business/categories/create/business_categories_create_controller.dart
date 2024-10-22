import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoes/src/utils/my_snackbar.dart';

class BusinessCategoriesCreateController{

  BuildContext? context;
  Function? refresh;


  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  Future? init(BuildContext context, Function refresh){
    this.context = context;
    this.refresh = refresh;
  }

  void createCategory(){
    String name = nameController.text;
    String description = descriptionController.text;

    if(name.isEmpty || description.isEmpty){
      MySnackBar.show(context!, 'Debe de ingresar todos los campos');
      return;
    }

    print('NAME ${name}');
    print('DESCRIPTION ${description}');


  }


  }