import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shoes/pages/client/address/list/client_address_list_controller.dart';
import 'package:shoes/src/models/address.dart';
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
      body: Stack(
        children: [
          Positioned(
            top: 0,
              child: _textSelectAddress()
          ),
          Container(
            margin: EdgeInsets.only(top: 50),
              child: _listAddress()
          )
        ],
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
        onPressed: _con.createOrder,
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

  Widget _noAddress(){
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(top: 30.0),
            child: Center(
              child: NoDataWidget(
                  text: 'Agrega una nueva dirección'),
            )
        ),
        _buttonNewAddress()
      ],
    );

  }

  Widget _listAddress(){
    return FutureBuilder(
        future: _con.getAddress(),
        builder: (context, AsyncSnapshot<List<AddressModel>>snapshot){

          if(snapshot.hasData){
            if(snapshot.data!.length > 0){
              return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),

                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (_, index){
                    return _radioSelectorAddress(snapshot.data![index], index);
                  }
              );
            }
            else{
              print("loco");
              return _noAddress();
            }
          }
          else{
            return _noAddress();
          }

        }
    );
  }

  Widget _radioSelectorAddress(AddressModel addressModel, int index){
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                    value: (index),
                    groupValue: _con.radioValue,
                    onChanged: _con.handleRadioValueChange,
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      addressModel?.address ?? '',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text
                      (
                      addressModel?.neighborhood ?? '',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    )
                  ],
                ),

              ],
            ),
            Divider(
              color: Colors.grey[400],
            )
          ],
        ),

      );
  }

  void refresh(){
    setState(() {
    });
  }
}
