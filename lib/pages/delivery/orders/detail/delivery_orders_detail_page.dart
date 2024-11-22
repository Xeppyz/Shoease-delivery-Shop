import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:shoes/pages/business/orders/detail/business_orders_detail_controller.dart';
import 'package:shoes/pages/client/orders/create/client_orders_create_controller.dart';
import 'package:shoes/pages/delivery/orders/detail/delivery_orders_detail_controller.dart';
import 'package:shoes/src/models/user.dart';
import 'package:shoes/src/utils/my_colors.dart';
import 'package:shoes/src/utils/relative_time_util.dart';
import 'package:shoes/src/widget/no_data_widget.dart';
import 'package:shoes/src/models/order.dart';
import '../../../../src/models/product.dart';

class DeliveryOrdersDetailPage extends StatefulWidget {

  Order? order;

  DeliveryOrdersDetailPage({ Key? key, @required this.order }) : super(key: key);

  @override
  State<DeliveryOrdersDetailPage> createState() => _DeliveryOrdersDetailPageState();
}

class _DeliveryOrdersDetailPageState extends State<DeliveryOrdersDetailPage> {
  DeliveryOrdersDetailController _con = new DeliveryOrdersDetailController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, widget.order!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.primaryColor,
            title: Text('Orden  #${_con.order?.id ?? ''} ', style: TextStyle(color: Colors.white),),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 15),
              child: Text('Total: ${_con.total}\$',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),))],
        ),
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Divider(
                  color: Colors.grey[400],
                  endIndent: 30, // MARGEN RIGHT
                  indent: 30, //MARGEN LEFT
                ),
                SizedBox(height: 10,),
                _textData('Cliente:', '${_con.order?.client?.name ?? ''} ${_con.order?.client?.lastname ?? '' }'),
                _textData('Entregar en:', '${_con.order?.address?.address ?? ''}'),
                SizedBox(height: 8,),
                _textData('Fecha pedido:', '${RelativeTimeUtil.getRelativeTime(_con.order?.timestamp ?? 0)}'),
               // _textTotalPrice(),
                _con.order?.status != 'ENTREGADO'  ?  _buttonDefaultBag() : Container()
              ],
            ),
          ),
        ),
      body: _con.order != null && _con.order!.products.isNotEmpty
          ? ListView(
        children: _con.order!.products.map((Product product) {
          return _cardProduct(product);
        }).toList(),
      )
          : Center(
        child: NoDataWidget(text: 'Carrito vacio'),
      ),
    );
  }




  Widget _textData(String tittle, String content){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text(tittle),
        subtitle: Text(content, maxLines: 2,),
      )
    );
  }

  Widget _buttonDefaultBag(){
    return Container(
      margin: EdgeInsets.only(left: 30,right: 30,top: 5, bottom: 20),
      child: ElevatedButton(
        onPressed: _con.updateOrder,
        style: ElevatedButton.styleFrom(
          backgroundColor:  _con.order?.status == 'EMPACADO' ? Colors.blue : Colors.green,
            padding: EdgeInsets.symmetric(vertical: 5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 40.0,
                alignment: Alignment.center,
                child: Text(
                _con.order?.status == 'EMPACADO'  ? 'Iniciar Entrega' : 'IR AL MAPA',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 50, top: 3),
                height: 30,
                child: Icon(Icons.directions_car, color: Colors.white,),
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget _cardProduct(Product product) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: [
          _imageProduct(product),
            SizedBox(
            width: 10.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product?.name ?? '',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0,),
              Text(
              'Cantidad: ${product.quantity}',
                style: TextStyle(fontSize: 13),
              ),

            ],
          ),

        ],
      ),
    );
  }

  Widget _imageProduct(Product product){
    return Container(
      width: 50.0,
      height: 50.0,
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.grey[200]),
      child: FadeInImage(
        image: product != null && product!.image1 != null
            ? NetworkImage(product!.image1!) as ImageProvider
            : AssetImage('assets/img/no-image.png'),
        fit: BoxFit.fill,
        fadeInDuration: Duration(milliseconds: 50),
        placeholder: AssetImage('assets/img/no-image.png'),
      ),
    );
  }


  void refresh() {
    setState(() {});
  }
}
