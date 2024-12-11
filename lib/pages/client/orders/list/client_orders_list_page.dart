import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shoes/pages/business/orders/list/business_order_list_controller.dart';
import 'package:shoes/pages/delivery/orders/list/delivery_orders_list_controller.dart';
import 'package:shoes/src/models/order.dart';

import '../../../../src/utils/my_colors.dart';
import '../../../../src/widget/no_data_widget.dart';
import 'client_orders_list_controller.dart';

class ClientOrdersListPage extends StatefulWidget {
  const ClientOrdersListPage({super.key});

  @override
  State<ClientOrdersListPage> createState() => _ClientOrdersListPageState();
}

class _ClientOrdersListPageState extends State<ClientOrdersListPage> {
  ClientOrdersListController _con = new ClientOrdersListController();

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
    return DefaultTabController(
      length: _con.status!.length,
      child: Scaffold(
          key: _con.key,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            child: AppBar(
              title: Text('Mis pedidos'),
              backgroundColor: MyColors.colorEFEFED,

              bottom: TabBar(
                indicatorColor: MyColors.primaryDark,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[400],
                isScrollable: true,
                tabs: List<Widget>.generate(_con.status.length, (index) {
                  return Tab(
                    child: Text(_con.status[index] ?? ''),
                  );
                }),
              ),
            ),
          ),
          body: TabBarView(
            children: _con.status.map((String status) {
              return FutureBuilder(
                  future: _con.getOrders(status),
                  builder: (context, AsyncSnapshot<List<Order>>snapshot){

                    if(snapshot.hasData){
                      if(snapshot.data!.length > 0){
                        return ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (_, index){
                              return _cardOrder(snapshot.data![index]);
                            }
                        );
                      }
                      else{
                        return NoDataWidget(text: 'No hay ordenes');
                      }
                    }
                    else{
                      return NoDataWidget(text: 'No hay ordenes');
                    }


                  }
              );

            }).toList(),
          )),
    );
  }

  Widget _cardOrder(Order? order) {
    return GestureDetector(
      onTap: (){
        _con.openBottomSheet(order!);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        height: 160,
        child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                      color: MyColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      )),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      '${order?.id}',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontFamily: 'NimbusSans'),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 40, left: 20, right: 20),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: double.infinity,
                      child: Text(
                        'Pedido: ${order?.timestamp}',
                        style: TextStyle(fontSize: 13),

                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: double.infinity,
                      child: Text(
                        'Repartidor: ${order?.delivery?.name ?? 'Repartidor no asignado'} ${order?.delivery?.lastname ?? ''}',
                        style: TextStyle(fontSize: 13),
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: double.infinity,
                      child: Text(
                        'Entregar en: ${order?.address?.address ?? ''}',
                        style: TextStyle(fontSize: 13),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  void refresh() {
    setState(() {});
  }
}
