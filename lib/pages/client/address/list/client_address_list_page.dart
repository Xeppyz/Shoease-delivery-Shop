import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shoes/pages/client/address/list/client_address_list_controller.dart';
import 'package:shoes/src/utils/my_colors.dart';
import 'package:shoes/src/widget/no_data_widget.dart';

class ClientAddressListPage extends StatefulWidget {
  const ClientAddressListPage({super.key});

  @override
  State<ClientAddressListPage> createState() => _ClientAddressListPageState();
}

class _ClientAddressListPageState extends State<ClientAddressListPage> {

   ClientAddressListController _con = new ClientAddressListController();
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
        title: Text('Direcciones'),
        actions: [
          _iconAdd()
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            _textSelectAddress(),
            Container(
              margin: EdgeInsets.only(top: 30.0),
                child: NoDataWidget(
                    text: 'Agrega una nueva dirección')
            ),
            _buttonNewAddress()
          ],
        ),
      ),
      bottomNavigationBar: _buttonAccept(),
    );
  }

  Widget _iconAdd(){
    return IconButton(
        onPressed: _con.goToNewAddres,
        icon: Icon(Icons.add_location_alt, color: MyColors.primaryColor)
    );
  }

  Widget _buttonAccept(){
    return Container(
      height: 50.0,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 30.0),
      child: ElevatedButton(
        onPressed: (){},
        child: Text(
          'ACEPTAR',
          style: TextStyle(
            color: Colors.white
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)
          ),
          backgroundColor: MyColors.primaryColor

        ),
      ),
    );
  }
   Widget _buttonNewAddress(){
     return Container(
       height: 40.0,

       child: ElevatedButton(
         onPressed: _con.goToNewAddres,
         child: Text(
           'Nueva dirección',
           style: TextStyle(
               color: Colors.black
           ),
         ),

       ),
     );
   }
  Widget _textSelectAddress() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
      child: Text(
        'Elige donde recibir tus compras',
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  void refresh(){
    setState(() {
    });
  }
}
