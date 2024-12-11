import 'dart:async';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shoes/pages/client/address/map/client_address_map_page.dart';
import 'package:location/location.dart' as location;
import 'package:geocoding/geocoding.dart';
import 'package:shoes/src/models/order.dart';
import 'package:shoes/src/provider/orders_provider.dart';
import 'package:shoes/src/utils/my_colors.dart';
import 'package:shoes/src/utils/my_snackbar.dart';
import 'package:shoes/src/utils/shared_pref.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../../src/api/environment.dart';
import '../../../../src/models/response_api.dart';
import '../../../../src/models/user.dart';

class ClientOrdersMapController {
  BuildContext? context;
  Function? refresh;
  Position? _position;
  String? addressName;
  LatLng? addressLatLng;

  CameraPosition initialPosition = CameraPosition(
      target: LatLng(12.129734398243688, -86.25262748828858), zoom: 14);

  Completer<GoogleMapController> _mapController = Completer();

  BitmapDescriptor? deliveryMarker;
  BitmapDescriptor? homeMarker;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Order? order;

  Set<Polyline> polylines = {};
  List<LatLng> points = [];
  User? user;
  SharedPref _sharedPref = new SharedPref();
  double? _distanceBetween;

  IO.Socket? socket;


  OrdersProvider _ordersProvider = new OrdersProvider();




  Future? init(BuildContext context, Function refresh) async  {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user') );
    _ordersProvider.init(context, user!);
    order = Order.fromJson(ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>);

    deliveryMarker = await createMarkerFromAsset('assets/img/delivery2.png');
    homeMarker = await createMarkerFromAsset('assets/img/home.png');
    socket = IO.io('http://${Environment.API_SHOEASE}/orders/delivery', <String, dynamic> {
      'transports' : ['websocket'],
      'autoConnect' : false
    });
    socket!.connect();
    socket!.on('position/${order!.id}', (data) {
      print("DATA EMITIDO DE CLIENT: ${data}");

      addMarker('delivery',
          data['lat'],
          data['lng'],
          'Delivery',
          '',
          deliveryMarker!);

    });


    print("ORDERRRR: ${order?.toJson()}");

    checkGPS();

  }

  void emitPosition(){
    socket?.emit('position', {
      'id_order' : order?.id,
      'lat' : _position?.latitude,
      'lng' : _position?.longitude
    });
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
    if (_position != null) {
      animateCameraToPosition(_position!.latitude, _position!.longitude);
    }
  }

  void call(){
    launch("tel://${order?.client?.phone}");
  }


  void isCloseToDeliveryPosition(){
      _distanceBetween = Geolocator.distanceBetween(
          _position?.latitude ?? 0.0,
          _position?.longitude ?? 0.0,
          order?.address?.lat ?? 0.0,
          order?.address?.lng ?? 0.0
      );
      
      print("---------------DISTANCE ${_distanceBetween} --------------");
  }

  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
      updateLocation();
    } else {
      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {
        updateLocation();
      }
    }
  }


  Future<void> setPolylines(LatLng from, LatLng to) async {
      PointLatLng pointFrom = PointLatLng(from.latitude, from.longitude);
      PointLatLng pointTo = PointLatLng(to.latitude, to.longitude);

      PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
          googleApiKey: Environment.API_GOOGLE,
        request: PolylineRequest(
            origin: pointFrom,
            destination: pointTo,
            mode: TravelMode.driving)
      );

      for(PointLatLng point in result.points){
        points.add(LatLng(point.latitude, point.longitude));
      }

      Polyline polyline = Polyline(
          polylineId: PolylineId('poly'),
        color: MyColors.primaryColor,
        points: points,
        width:  5
      );

      polylines.add(polyline);


      refresh!();

  }

  void addMarker(String markerId, double lat, double lng, String tittle, String content, BitmapDescriptor iconMarker){
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
        markerId: id,
      icon: iconMarker,
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: tittle, snippet: content)
    );

    markers[id] = marker;
    refresh!();

  }

  void selectRefPoint() {
    Map<String, dynamic> data = {
      'address': addressName,
      'lat': addressLatLng?.latitude,
      'lng': addressLatLng?.longitude
    };
    Navigator.pop(context!, data);
  }


  Future<BitmapDescriptor> createMarkerFromAsset(String path) async {
      ImageConfiguration configuration = ImageConfiguration();
      BitmapDescriptor descriptor = await BitmapDescriptor.fromAssetImage(configuration, path);
      return descriptor;
  }

  Future<Null> setLocationDraggableInfo() async {
    if (initialPosition != null) {
      double lat = initialPosition.target.latitude;
      double lng = initialPosition.target.longitude;

      List<Placemark> address = await placemarkFromCoordinates(lat, lng);

      if (address.isNotEmpty) {
        String? direction = address[0].thoroughfare;
        String? street = address[0].subThoroughfare;
        String? city = address[0].locality;
        String? department = address[0].administrativeArea;
        String? country = address[0].country;
        addressName = '$direction #$street, $city, $department';
        addressLatLng = LatLng(lat, lng);
        refresh!();
      }
    }
  }

  void dispose(){
    socket?.disconnect();
  }

  void updateLocation() async {
    try {
      animateCameraToPosition(order!.lat!, order!.lng!);

      addMarker('delivery',
          order!.lat!,
          order!.lng!,
          'Delivery',
          '',
          deliveryMarker!);
        addMarker('home', order?.address?.lat ?? 0.0, order?.address?.lng ?? 0.0, 'Lugar de entrega', '', homeMarker!);

        LatLng from = new LatLng(order?.lat ?? 0.0,   order?.lng ?? 0.0);
        LatLng to = new LatLng(order?.address?.lat ?? 0.0, order?.address?.lng ?? 0.0);

        setPolylines(from, to);

       refresh!();

    } catch (e) {
      print("Error: $e");
    }
  }

  Future animateCameraToPosition(double lat, double lng) async {
    GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(lat, lng),
            zoom: 13,
            bearing: 0
        )
    ));
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verifica si los servicios de localización están habilitados.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Cuando los permisos están concedidos, obtiene la posición del dispositivo.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}

