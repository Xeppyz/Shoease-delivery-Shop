import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shoes/pages/client/products/list/client_products_list_controller.dart';
import 'package:shoes/src/utils/my_colors.dart';

class ClienteProductsListPage extends StatefulWidget {
  const ClienteProductsListPage({super.key});

  @override
  State<ClienteProductsListPage> createState() => _ClienteProductsListPageState();
}

class _ClienteProductsListPageState extends State<ClienteProductsListPage> {

  ClienteProductsListController _con = new ClienteProductsListController();
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
      key: _con.key,
      appBar: AppBar(
        leading: _menuDrawer(),
      ),
      drawer: _drawer(),
      body: Center(
        child: ElevatedButton(
          onPressed: _con.logout,
          child: Text(
            'Cerrar sesión'
          )
        )
      ),
    );
  }



  Widget _menuDrawer(){
    return GestureDetector(
      onTap: _con.openDrawer,
      child: Container(
        margin: EdgeInsets.only(left: 20.0),
        alignment: Alignment.centerLeft,
        child: Image.asset('assets/img/menu.png', width: 20, height: 20,),
      ),

    );
  }

  Widget _drawer(){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: MyColors.primaryColor
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(

                  '${_con.user?.name ?? ''} ${_con.user?.lastname ?? ''}',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                  maxLines: 1,
                ),
                Text(
                  _con.user?.email ?? '',
                  style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.grey[300],
                      fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic

                  ),
                  maxLines: 1,
                ),
                Text(
                  _con.user?.phone ?? '',
                  style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.grey[300],
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic

                  ),
                  maxLines: 1,
                ),
                ClipOval(
                  child: FadeInImage(
                    image: _con.user?.image != null
                        ? NetworkImage(_con.user!.image!) as ImageProvider<Object>
                        : AssetImage('assets/img/no-image.png') as ImageProvider<Object>,
                    placeholder: AssetImage('assets/img/no-image.png'),
                    fit: BoxFit.cover,
                    fadeInDuration: Duration(milliseconds: 50),
                    width: 65.0,
                    height: 65.0,
                  ),
                )

              ],
            ),
            ),
          ListTile(
            onTap: _con.goToUpdateProfile,
            title: Text('Editar Perfil'),
            trailing: Icon(Icons.edit),
          ),
          ListTile(
            title: Text('Mis pedidos'),
            trailing: Icon(Icons.shopping_cart),

          ),
          _con.user != null ?
           _con.user!.roles!.length > 1 ?
          ListTile(
            onTap: _con.goToRoles,
            title: Text('Seleccionar rol'),
            trailing: Icon(Icons.person),

          ):Container():Container(),

          ListTile(
            onTap: _con.logout,
            title: Text('Cerrar sesión'),
            trailing: Icon(Icons.power_settings_new),

          ),
        ],
      ),
    );
  }

  void refresh(){
    setState(() {

    });
  }
}
