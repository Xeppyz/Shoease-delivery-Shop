import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shoes/pages/business/orders/list/business_order_list_controller.dart';

import '../../../../src/utils/my_colors.dart';


class BusinessOrdersListPage extends StatefulWidget {
  const BusinessOrdersListPage({super.key});

  @override
  State<BusinessOrdersListPage> createState() => _BusinessOrdersListPageState();
}

class _BusinessOrdersListPageState extends State<BusinessOrdersListPage> {

  BusinnesOrderListController _con = new BusinnesOrderListController();

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
        child: Text(
          'Business Orders list'
        ),
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
            onTap: _con.goToCategeoryCreate,
            title: Text('Crear categoria'),
            trailing: Icon(Icons.add_business_rounded),

          ),
          ListTile(
            onTap: _con.goToProductsCreate,
            title: Text('Crear producto'),
            trailing: Icon(Icons.add_circle),

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
