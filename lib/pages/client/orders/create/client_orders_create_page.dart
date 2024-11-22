import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:shoes/pages/client/orders/create/client_orders_create_controller.dart';
import 'package:shoes/src/utils/my_colors.dart';
import 'package:shoes/src/widget/no_data_widget.dart';

import '../../../../src/models/product.dart';

class ClientOrdersCreatePage extends StatefulWidget {
  const ClientOrdersCreatePage({super.key});

  @override
  State<ClientOrdersCreatePage> createState() => _ClientOrdersCreatePageState();
}

class _ClientOrdersCreatePageState extends State<ClientOrdersCreatePage> {
  ClientOrdersCreateController _con = new ClientOrdersCreateController();

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
            title: Text('Mi orden')
        ),
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height * 0.23,
          child: Column(
            children: [
              Divider(
                color: Colors.grey[400],
                endIndent: 30, // MARGEN RIGHT
                indent: 30, //MARGEN LEFT
              ),
              _textTotalPrice(),
              _buttonDefaultBag()
            ],
          ),
        ),
        body: _con.selectedProduct.length > 0
            ? ListView(
                children: _con.selectedProduct.map((Product product) {
                  return _cardProduct(product);
                }).toList(),
              )
            : Center(
            child: NoDataWidget(text: 'Carrito vacio')));
  }


  Widget _buttonDefaultBag(){
    return Container(
      margin: EdgeInsets.only(left: 30,right: 30,top: 10),
      child: ElevatedButton(
        onPressed: _con.goToAddress,
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 50.0,
                alignment: Alignment.center,
                child: Text(
                  'Checkout',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    color: MyColors.primaryColor
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 50, top: 6),
                height: 30,
                child: Icon(Icons.check_circle, color: Colors.green,),
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
              _addOrRemoveItem(product)
            ],
          ),
          Spacer(),
          Column(
            children: [
              _textPrice(product),
              _iconDelete(product)
            ],
          )
        ],
      ),
    );
  }
  Widget _iconDelete(Product product){
    return IconButton(
        onPressed: (){
          _con.deleteItem(product);
        },
        icon: Icon(Icons.delete_forever_rounded, color: MyColors.primaryColor,)
    );
  }

  Widget _textTotalPrice(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
            Text('${_con.total}\$', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
          ],
      ),
    );  
  }

  Widget _textPrice(Product product){
    return Container(
      margin: EdgeInsets.only(top: 10, ),
      child: Text(
        '${product.price! * product!.quantity!}',
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }


  Widget _imageProduct(Product product){
    return Container(
      width: 90.0,
      height: 90.0,
      padding: EdgeInsets.all(10.0),
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
  Widget _addOrRemoveItem(Product product){
    return Row(
      children: [
        GestureDetector(
          onTap: (){
            _con.removeItem(product);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 7.0),
            decoration: BoxDecoration(
                borderRadius:
                BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0)
                ),
                color: Colors.grey[200]
            ),
          
            child: Text('-'),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 7.0),
          color: Colors.grey[200],
          child: Text('${product?.quantity ?? 0}'),
        ),
        GestureDetector(
          onTap: (){
            _con.addItem(product);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 7.0),
            decoration: BoxDecoration(
                borderRadius:
                BorderRadius.only(
                    topRight: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0)
                ),
                color: Colors.grey[200]
            ),

            child: Text('+'),
          ),
        ),
      ],
    );
  }

  void refresh() {
    setState(() {});
  }
}
