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
}
