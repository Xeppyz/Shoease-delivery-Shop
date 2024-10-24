import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shoes/pages/business/categories/create/business_categories_create_controller.dart';
import 'package:shoes/pages/business/orders/list/business_order_list_controller.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:shoes/src/models/category.dart';


import '../../../../src/utils/my_colors.dart';
import 'business_products_create_controller.dart';

class BusinessProductsCreatePage extends StatefulWidget {
  const BusinessProductsCreatePage({super.key});

  @override
  State<BusinessProductsCreatePage> createState() => _BusinessProductsCreatePageState();
}

class _BusinessProductsCreatePageState extends State<BusinessProductsCreatePage> {

  BusinessProductsCreateController _con = new BusinessProductsCreateController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevo producto'),
      ),
      body: ListView(
          children: [
            SizedBox(height: 10.0,),
            _textFieldName(),
            _textFieldDescription(),
            _textFieldPrice(),
            Container(
              height: 100.0,
              margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _cardImage(null, 1),
                  _cardImage(null, 2),
                  _cardImage(null, 3),
                ],
              ),
            ),
            _dropDownCategories(_con.categories),
          ],

      ),
      bottomNavigationBar: _buttonCreate(),
    );
  }


  //_dropDown catalog
  Widget  _dropDownCategories(List<Category> categories){

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: Material(
          elevation: 2.0,
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
               Row(
                 children: [
                   Icon(
                     Icons.search,
                     color: MyColors.primaryDark,
                   ),
                   SizedBox(height: 15,),
                   Text(
                     'Categorias',
                     style: TextStyle(
                         color: Colors.grey,
                         fontSize: 16
                     ),
                   )
                 ],
               ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: DropdownButton(
                    underline: Container(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_drop_down_circle,
                        color: MyColors.primaryDark,
                      ),
                    ),
                      elevation: 5,
                      isExpanded: true,
                      hint: Text(
                        'Seleccionar categoria',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16

                        ),
                      ),
                      items: _dropDownItems(categories),
                    value: _con.idCategory,
                    onChanged: (option){
                      setState(() {
                        print("CATEGORIA SELECCIONADA: ${option}");
                        _con.idCategory = option; // WE'VE PUT THE VALUE SELECTION
                      });
                    }
                  ),
                )



              ],
            ),
          ),
        ),
      );
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<Category> categories){
    List<DropdownMenuItem<String>> list = [];
    categories.forEach((category) {
        list.add(DropdownMenuItem(
            child:Text(category.name!),
          value: category.id,

        ));
    });

    return list;
  }
  //cards
  Widget _cardImage(File? imageFile, int numberFile){
    return imageFile != null
        ? Card(
      elevation: 3.0,
      child: Container(
        height: 100.0,
        width: MediaQuery.of(context).size.width * 0.26,
        child: Image.file(
          imageFile,
          fit: BoxFit.cover,

        ),
      ),
    )
        : Card(
      elevation: 3.0,
      child: Container(
        height: 140.0,
        width: MediaQuery.of(context).size.width * 0.26,
        child: Image(
          image: AssetImage('assets/img/add_image.png'),
        )
      ),
    );
  }

  Widget _buttonCreate(){
    return Container(
      height: 50.0,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
      child: ElevatedButton(

        onPressed: _con.createProduct ,
        child: Text(
          'Crear categoria',
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

  //field to register new category
  Widget _textFieldName(){
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30.0)
      ),
      child: TextField(
        controller: _con.nameController ,
        maxLines: 2,
        maxLength: 100,
        decoration:InputDecoration(
            hintText: 'Nombre del producto',
            hintStyle: TextStyle(
                color: MyColors.primaryDark
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15.0),
            suffixIcon: Icon(
              Icons.production_quantity_limits_outlined,
              color: MyColors.primaryColor,
            )
        ) ,
      ),
    );
  }
  Widget _textFieldDescription(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(20.0)
      ),
      child: TextField(
        controller: _con.descriptionController ,
        maxLength: 255,
        maxLines: 3,
        decoration:InputDecoration(
            hintText: 'Descripción',
            hintStyle: TextStyle(
                color: MyColors.primaryDark
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15.0),
            suffixIcon: Icon(
              Icons.description_rounded,
              color: MyColors.primaryColor,
            )
        ) ,
      ),
    );
  }
  Widget _textFieldPrice(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30.0)
      ),
      child: TextField(
        controller: _con.priceController,
        maxLines: 1,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          CurrencyInputFormatter(
            trailingSymbol: CurrencySymbols.DOLLAR_SIGN,
            thousandSeparator: ThousandSeparator.Period,

          ),
        ],
        decoration:InputDecoration(
            hintText: 'Precio del producto',
            hintStyle: TextStyle(
                color: MyColors.primaryDark
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15.0),
            suffixIcon: Icon(
              Icons.monetization_on,
              color: MyColors.primaryColor,
            )
        ) ,
      ),
    );
  }

  void refresh(){
    setState(() {

    });
  }
}
