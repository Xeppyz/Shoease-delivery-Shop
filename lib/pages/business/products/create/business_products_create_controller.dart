import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:shoes/src/models/category.dart';
import 'package:shoes/src/models/response_api.dart';
import 'package:shoes/src/provider/categories_provider.dart';
import 'package:shoes/src/utils/my_snackbar.dart';
import 'package:shoes/src/utils/shared_pref.dart';

import '../../../../src/models/user.dart';

class BusinessProductsCreateController{

  BuildContext? context;
  Function? refresh;

  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController priceController = TextEditingController(); // Usa TextEditingController
  CategoriesProvider _categoriesProvider = new CategoriesProvider();
  User? user;
  SharedPref sharedPref = new SharedPref();
  List<Category> categories = [];
  String? idCategory;// Save ID category


  Future? init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await sharedPref.read('user'));
    this._categoriesProvider.init(context, user!);

    getCategories();
  }
  void getCategories()async{
    categories = await _categoriesProvider.getAll();
    refresh!();
  }
  void createProduct() async{
    String name = nameController.text;
    String description = descriptionController.text;
    String price = priceController.text;

    if(name.isEmpty || description.isEmpty){
      MySnackBar.show(context!, 'Debe de ingresar todos los campos');
      return;
    }

    print("name ${name}");
    print("description ${description}");
    print("money   ${price}");


    }
  }
