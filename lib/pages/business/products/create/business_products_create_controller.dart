import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoes/src/models/category.dart';
import 'package:shoes/src/models/product.dart';
import 'package:shoes/src/models/response_api.dart';
import 'package:shoes/src/provider/categories_provider.dart';
import 'package:shoes/src/utils/my_snackbar.dart';
import 'package:shoes/src/utils/shared_pref.dart';

import '../../../../src/models/user.dart';

class BusinessProductsCreateController{

  BuildContext? context;
  Function? refresh;
  PickedFile? pickedFile;
  File? imageFile1;
  File? imageFile2;
  File? imageFile3;

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
    // Quitar símbolos y separadores para convertir correctamente a double.
    String cleanText = priceController.text
        .replaceAll(RegExp(r'[^0-9.]'), ''); // Mantén solo números y punto decimal

    double? price = double.tryParse(cleanText);

    if (price == null) {
      print("Error: Precio no válido");
      return;
    }


    if(name.isEmpty || description.isEmpty || price == 0){
      MySnackBar.show(context!, 'Debe de ingresar todos los campos');
      return;
    }

    if(imageFile1 == null || imageFile2 == null || imageFile3 == null){
      MySnackBar.show(context!, 'Selecciona las tres imagenes');
      return;
    }
    if(idCategory == null){
      MySnackBar.show(context!, 'Selecciona una categoria');
      return;
    }

    Product product = new Product(
        name: name,
        description: description,
        price: price,
        idCategory: int.parse(idCategory!),

    );

    print("formulario Producto ${product.toJson()}");

    print("name ${name}");
    print("description ${description}");
    print("money   ${price}");


    }

  Future selectImage(ImageSource imageSource, int numberFile) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      if(numberFile == 1){
        imageFile1 = File(pickedFile.path);
      }
      else if(numberFile == 2){
        imageFile2 = File(pickedFile.path);
      }
      else if(numberFile == 3){
        imageFile3 = File(pickedFile.path);
      }
    }
    Navigator.pop(context!);
    refresh!();
  }


  void showAlertDialog(int numberFile){
    Widget _galleryButton = ElevatedButton(
        onPressed: (){
          selectImage(ImageSource.gallery, numberFile);
        },
        child: Text('GALERIA')
    );
    Widget _cameraButton = ElevatedButton(
        onPressed: (){
          selectImage(ImageSource.camera, numberFile);
        },
        child: Text('CAMARA')
    );
    AlertDialog alertDialog = AlertDialog(
      title: Text('Selecciona tu imagen'),
      actions: [
        _galleryButton,
        _cameraButton
      ],
    );

    showDialog(
        context: context!,
        builder: (BuildContext? context){
          return alertDialog;
        }
    );
  }
  }
