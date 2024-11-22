import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:shoes/pages/business/orders/detail/business_orders_detail_controller.dart';
import 'package:shoes/pages/client/orders/create/client_orders_create_controller.dart';
import 'package:shoes/src/models/user.dart';
import 'package:shoes/src/utils/my_colors.dart';
import 'package:shoes/src/utils/relative_time_util.dart';
import 'package:shoes/src/widget/no_data_widget.dart';
import 'package:shoes/src/models/order.dart';
import '../../../../src/models/product.dart';

class BusinessOrdersDetailPage extends StatefulWidget {

  Order? order;

   BusinessOrdersDetailPage({ Key? key, @required this.order }) : super(key: key);

  @override
  State<BusinessOrdersDetailPage> createState() => _BusinessOrdersDetailPageState();
}

class _BusinessOrdersDetailPageState extends State<BusinessOrdersDetailPage> {
  BusinessOrdersDetailController _con = new BusinessOrdersDetailController();

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
          backgroundColor: MyColors.primaryDark,
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
          height: MediaQuery.of(context).size.height * 0.5,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Divider(
                  color: Colors.grey[400],
                  endIndent: 30, // MARGEN RIGHT
                  indent: 30, //MARGEN LEFT
                ),
                SizedBox(height: 10,),
                _textDescription(),
                SizedBox(height: 10,),
                _con.order?.status != 'PAGADO' ?  _deliveryData() : Container(),
               _con.order?.status == 'PAGADO' ? _dropDown(_con.users) : Container(),
                SizedBox(height: 10,),
                _textData('Cliente:', '${_con.order?.client?.name ?? ''} ${_con.order?.client?.lastname ?? '' }'),
                SizedBox(height: 8,),
                _textData('Entregar en:', '${_con.order?.address?.address ?? ''}'),
                SizedBox(height: 8,),
                _textData('Fecha pedido:', '${RelativeTimeUtil.getRelativeTime(_con.order?.timestamp ?? 0)}'),
               // _textTotalPrice(),
                _con.order?.status == 'PAGADO' ? _buttonDefaultBag() : Container()
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


  Widget _textDescription(){
    return Container(
      alignment: Alignment.centerLeft,
        margin: EdgeInsets.symmetric(horizontal: 30.0),
        child: Text(
           _con.order?.status == 'PAGADO' ? "Asignar repartidor" : 'Repartidor asignado' ,
            style: TextStyle(
                fontStyle: FontStyle.italic,
                color: MyColors.primaryColor,
              fontSize: 20
            )
        )
    );
  }

  Widget  _dropDown(List<User> users){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Material(
        elevation: 2.0,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Container(
          padding: EdgeInsets.all(0),
          child: Column(
            children: [

              Container(
                padding: EdgeInsets.symmetric(horizontal: 33.0, vertical: 15.0),
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
                      'Repartidores',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16

                      ),
                    ),
                    items: _dropDownItems(users),
                   value: _con.idDelivery,
                    onChanged: (option){
                      setState(() {
                        print("Repartidor seleccionado: ${option}");
                        _con.idDelivery = option; // WE'VE PUT THE VALUE SELECTION
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

  Widget _deliveryData(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            child: FadeInImage(
              image: _con.order?.delivery?.image != null
                  ? NetworkImage(_con.order!.delivery!.image!) as ImageProvider
                  : AssetImage('assets/img/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('assets/img/no-image.png'),
            ),
          ),
          const SizedBox(width: 5),
          Text('${_con.order?.delivery?.name ?? ''} ${_con.order?.delivery?.lastname ?? ''}'),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<User> users) {
    List<DropdownMenuItem<String>> list = [];
    users.forEach((user) {
      list.add(DropdownMenuItem(
        value: user.id,
        child: Row(
          children: [
             Container(
              height: 60,
              width: 60,
              child: FadeInImage(
                image: user.image != null
                    ? NetworkImage(user.image!) as ImageProvider
                    : AssetImage('assets/img/no-image.png'),
                fit: BoxFit.cover,
                fadeInDuration: Duration(milliseconds: 50),
                placeholder: AssetImage('assets/img/no-image.png'),
              ),
            ),
            const SizedBox(width: 5),
            Text(user.name!),
          ],
        ),
      ));
    });
    return list;
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
                  'DESPACHAR',
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
                margin: EdgeInsets.only(left: 50, top: 3),
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
