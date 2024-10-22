import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shoes/pages/business/categories/create/business_categories_create_controller.dart';
import 'package:shoes/pages/business/orders/list/business_order_list_controller.dart';

import '../../../../src/utils/my_colors.dart';

class BusinessCategoriesCreatePage extends StatefulWidget {
  const BusinessCategoriesCreatePage({super.key});

  @override
  State<BusinessCategoriesCreatePage> createState() => _BusinessCategoriesCreatePageState();
}




class _BusinessCategoriesCreatePageState extends State<BusinessCategoriesCreatePage> {


  BusinessCategoriesCreateController _con = new BusinessCategoriesCreateController();

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
        title: Text('Nueva categoria'),
      ),
      body: Column(
        children: [
          SizedBox(height: 30.0,),
          _textFieldName(),
          _textFieldDescription()
        ],
      ),
      bottomNavigationBar: _buttonCreate(),
    );
  }

  Widget _buttonCreate(){
    return Container(
      height: 50.0,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
      child: ElevatedButton(
        onPressed: _con.createCategory ,
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
      margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(50.0)
      ),
      child: TextField(
        controller: _con.nameController ,
        decoration:InputDecoration(
            hintText: 'Nombre de la categoria',
            hintStyle: TextStyle(
                color: MyColors.primaryDark
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15.0),
            suffixIcon: Icon(
              Icons.list_alt,
              color: MyColors.primaryColor,
            )
        ) ,
      ),
    );
  }
  Widget _textFieldDescription(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
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

  void refresh(){
    setState(() {

    });
  }
}
