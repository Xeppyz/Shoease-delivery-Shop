import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shoes/pages/client/products/list/client_products_list_controller.dart';

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
     _con.init(context);
   });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      onTap: (){},
      child: Container(
        alignment: Alignment.centerLeft,
        child: Image.asset('assets/img/menu.png', width: 20, height: 20,),
      ),

    );
  }

  Widget _drawer(){
    return Drawer(
      child: ListView(
        children: [
            DrawerHeader(child:
            Column(
              children: [
                Text(
                  'Nombre de usuario',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                  maxLines: 1,
                )
              ],
            )
            )
        ],
      ),
    );
  }
}
