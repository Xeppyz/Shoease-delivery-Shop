import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shoes/pages/client/address/list/client_address_list_controller.dart';
import 'package:shoes/src/utils/my_colors.dart';
import 'package:shoes/src/widget/no_data_widget.dart';

import 'client_orders_map_controller.dart';

class ClientOrdersMapPage extends StatefulWidget {
  const ClientOrdersMapPage({super.key});

  @override
  State<ClientOrdersMapPage> createState() => _ClientOrdersMapPageState();
}

class _ClientOrdersMapPageState extends State<ClientOrdersMapPage> {

   ClientOrdersMapController _con = new ClientOrdersMapController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        _con.init(context, refresh);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _con.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Container(
            height: MediaQuery.of(context).size.height *0.68,
              child: _googleMaps()
          ),
          SafeArea(
            child: Column(
              children: [
                _buttonCenterPosition(),
                Spacer(),
                _cardOrderInfo(),
              ],
            ),
          ),

        ],
      ),


    );
  }


  void refresh(){
    if(!mounted) return;
    setState(() {
    });
  }

  Widget _cardOrderInfo(){
    return Container(
      height: MediaQuery.of(context).size.height * 0.33,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
       borderRadius: BorderRadius.only(
           topRight: Radius.circular(20),
           topLeft: Radius.circular(20)
       ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0,3)
          )
        ]
      ),
      child: Column(
        children: [
        _listTileAddress(_con.order?.address?.neighborhood ?? 'Not found', 'Barrio', Icons.delivery_dining),
        _listTileAddress(_con.order?.address?.address ?? 'Not found', 'Dirección', Icons.location_on),
          Divider(color: Colors.grey[400], indent: 30, endIndent: 30,),
          _clientInfo(),

        ],
      ),
    );
  }

  Widget _clientInfo(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
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
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              '${_con.order?.delivery?.name ?? ''}  ${_con.order?.delivery?.lastname ?? ''}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 17
              ),
              maxLines: 1,
            ),
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.grey[200],
            ),
            child: IconButton(
              onPressed: _con.call,
              icon: Icon(Icons.phone_forwarded, color: Colors.black,),
            ),
          )
        ],
      ),
    );
  }
  Widget _listTileAddress(String title, String subtitle, IconData iconData){
    return Container(
      child: ListTile(
        title: Text(
          title ?? '',
          style: TextStyle(
            fontSize: 13
          ),
        ),
        subtitle: Text(subtitle),
        trailing: Icon(iconData) ,
      ),
    );
  }
  Widget _buttonCenterPosition(){
    return GestureDetector(
      onTap: (){},
      child: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Card(
          shape: CircleBorder(),
          color: Colors.white,
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.location_searching, color: Colors.grey[600],size: 20 ,),
          ),
        ),
      ),
    );
}


  Widget _googleMaps(){
    return GoogleMap(
      style: '[{"elementType":"geometry","stylers":[{"color":"#242f3e"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#746855"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#242f3e"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#263c3f"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#6b9a76"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#38414e"}]},{"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#212a37"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#9ca5b3"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#746855"}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#1f2835"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#f3d19c"}]},{"featureType":"transit","elementType":"geometry","stylers":[{"color":"#2f3948"}]},{"featureType":"transit.station","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#17263c"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#515c6d"}]},{"featureType":"water","elementType":"labels.text.stroke","stylers":[{"color":"#17263c"}]}]',
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      markers: Set<Marker>.of(_con.markers.values),
      polylines: _con.polylines,
    );


  }

}
