
import 'package:flutter/cupertino.dart';
import  'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shoes/pages/client/update/client_update_controller.dart';

import '../../../src/utils/my_colors.dart';

class ClientUpdatePage extends StatefulWidget {
  const ClientUpdatePage({super.key});

  @override
  State<ClientUpdatePage> createState() => _ClientUpdatePageState();
}

class _ClientUpdatePageState extends State<ClientUpdatePage> {
  ClientUpdateController _con = new ClientUpdateController();

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
        title: Text('Editar Perfil'),
      ),
      body: Container(
        width: double.infinity,
        child:SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50.0,),
              _imageUser(),
              SizedBox(height: 30.0,),
              _textFieldName(),
              _textFieldLastName(),
              _textFieldNumber(),

            ],
          ),
        ),
      ),
      bottomNavigationBar: _buttonLogin(),
    );
  }

  Widget _imageUser(){
    return GestureDetector(
      onTap: _con.showAlertDialog,
      child: CircleAvatar(
        backgroundImage: _con.imageFile != null
            ? FileImage(_con.imageFile!) as ImageProvider<Object>
            : _con.user?.image != null
              ? NetworkImage(_con.user!.image!)
              : AssetImage('assets/img/user_profile_2.png') as ImageProvider<Object>,
        radius: 60,
        backgroundColor: Colors.grey[400],
      ),
    );
  }




  Widget _textFieldName(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(50.0)
      ),
      child: TextField(
        controller: _con.nameController,
        decoration:InputDecoration(
            hintText: 'Nombre',
            hintStyle: TextStyle(
                color: MyColors.primaryDark
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15.0),
            prefixIcon: Icon(
              Icons.person,
              color: MyColors.primaryColor,
            )
        ) ,
      ),
    );
  }
  Widget _textFieldLastName(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(50.0)
      ),
      child: TextField(
        controller: _con.lastNameController,
        decoration:InputDecoration(
            hintText: 'Apellido',
            hintStyle: TextStyle(
                color: MyColors.primaryDark
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15.0),
            prefixIcon: Icon(
              Icons.drive_file_rename_outline_rounded,
              color: MyColors.primaryColor,
            )
        ) ,
      ),
    );
  }
  Widget _textFieldNumber(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(50.0)
      ),
      child: TextField(
        controller: _con.numberController,
        keyboardType: TextInputType.number,
        decoration:InputDecoration(
            hintText: 'Teléfono',
            hintStyle: TextStyle(
                color: MyColors.primaryDark
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15.0),
            prefixIcon: Icon(
              Icons.phone_forwarded,
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
        onPressed:_con.isEnable ? _con.update : null,
        child: Text(
          'Actualizar Perfil',
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


  void refresh(){
    setState(() {

    });
  }
}