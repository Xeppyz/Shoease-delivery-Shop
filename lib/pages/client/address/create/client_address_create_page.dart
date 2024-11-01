import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shoes/pages/client/address/create/client_address_create_controller.dart';

import '../../../../src/utils/my_colors.dart';

class ClientAddressCreatePage extends StatefulWidget {
  const ClientAddressCreatePage({super.key});

  @override
  State<ClientAddressCreatePage> createState() => _ClientAddressCreatePageState();
}

class _ClientAddressCreatePageState extends State<ClientAddressCreatePage> {

   ClientAddressCreateController _con = new ClientAddressCreateController();
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
        title: Text('Nueva dirección'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _textSelectAddress(),
            _textFieldAddress(),
            _textFieldNeighborhood(),
            _textFieldRefPoint()
          ],
        ),
      ),
      bottomNavigationBar: _buttonAccept(),
    );
  }

  void refresh(){
    setState(() {
    });
  }

  Widget _textFieldAddress(){
    return Container(

      margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Dirección',
          suffixIcon: Icon(
            Icons.location_on,
            color: MyColors.primaryColor,
          )
        ),
      )
    );
  }

  Widget _textFieldNeighborhood(){
     return Container(

         margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
         child: TextField(
           decoration: InputDecoration(
               labelText: 'Barrio',
               suffixIcon: Icon(
                 Icons.location_city_outlined,
                 color: MyColors.primaryColor,
               )
           ),
         )
     );
   }

   Widget _textFieldRefPoint(){
     return Container(

         margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
         child: TextField(
           onTap: _con.openMap,
           autofocus: false,
           focusNode: AlwaysDisabledFocusNode(),
           decoration: InputDecoration(
               labelText: 'Punto de referencia',
               suffixIcon: Icon(
                 Icons.map_rounded,
                 color: MyColors.primaryColor,
               )
           ),
         )
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
           'CREAR DIRECCIÓN',
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

   Widget _textSelectAddress() {
     return Container(
       alignment: Alignment.centerLeft,
       margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
       child: Text(
         'Complete sus datos',
         style: TextStyle(
             fontSize: 19,
             fontWeight: FontWeight.bold
         ),
       ),
     );
   }

}


class AlwaysDisabledFocusNode extends FocusNode{
  @override
  bool get hasFocus => false;
}
