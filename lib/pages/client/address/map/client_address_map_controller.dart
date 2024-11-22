import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shoes/pages/client/address/map/client_address_map_page.dart';
import 'package:location/location.dart' as location;
import 'package:geocoding/geocoding.dart';

class ClientAddressMapController {
  BuildContext? context;
  Function? refresh;
  Position? _position;
  String? addressName;
  LatLng? addressLatLng;

  CameraPosition initialPosition = CameraPosition(
      target: LatLng(12.129734398243688, -86.25262748828858), zoom: 14);

  Completer<GoogleMapController> _mapController = Completer();

  Future? init(BuildContext context, Function refresh) {
    this.context = context;
    this.refresh = refresh;
    checkGPS();
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
    if (_position != null) {
      animateCameraToPosition(_position!.latitude, _position!.longitude);
    }
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

  void selectRefPoint() {
    Map<String, dynamic> data = {
      'address': addressName,
      'lat': addressLatLng?.latitude,
      'lng': addressLatLng?.longitude
    };
    Navigator.pop(context!, data);
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

  void updateLocation() async {
    try {
      _position = await _determinePosition(); // Obtén la posición actual
      if (_position != null) {
        animateCameraToPosition(_position!.latitude, _position!.longitude);
      }
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

