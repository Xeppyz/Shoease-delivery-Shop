import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:shoes/src/models/category.dart';
import 'package:shoes/src/models/response_api.dart';
import 'package:shoes/src/provider/categories_provider.dart';
import 'package:shoes/src/utils/my_snackbar.dart';
import 'package:shoes/src/utils/shared_pref.dart';

import '../../../../src/models/user.dart';

class BusinessCategoriesCreateController{

  BuildContext? context;
  Function? refresh;


  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  CategoriesProvider _categoriesProvider = new CategoriesProvider();
  User? user;
  SharedPref sharedPref = new SharedPref();


  Future? init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await sharedPref.read('user'));
    this._categoriesProvider.init(context, user!);


  }

  void createCategory() async{
    String name = nameController.text;
    String description = descriptionController.text;

    if(name.isEmpty || description.isEmpty){
      MySnackBar.show(context!, 'Debe de ingresar todos los campos');
      return;
    }

    Category category = new Category(
        name: name,
        description: description);

    ResponseApi? responseApi = await _categoriesProvider.create(category);

    MySnackBar.show(context!, responseApi!.message!);
    if(responseApi!.success!){
      nameController.text = '';
      descriptionController.text = '';


    }

  }



  }