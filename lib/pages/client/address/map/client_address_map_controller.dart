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
    animateCameraToPosition(_position!.latitude, _position!.longitude);
  }

  void checkGPS() async {
    bool isLocationEnable = await Geolocator.isLocationServiceEnabled();
    if(isLocationEnable){
      updateLocation();
    }
    else{
      bool locationGPS = await location.Location().requestService();
      //bool locationGPS = false;

      if(locationGPS){
        updateLocation();
      }
    }

  }

  Future<Null> setLocationDraggableInfo() async {
    if(initialPosition != null){
      double lat = initialPosition.target.latitude;
      double lng = initialPosition.target.longitude;

      List<Placemark> address = await placemarkFromCoordinates(lat, lng);

      if(address != null){
        if(address.length > 0){
          String? direction = address[0].thoroughfare;
          String? street = address[0].subThoroughfare;
          String? city = address[0].locality;
          String? department = address[0].administrativeArea;
          String? country = address[0].country;
          addressName = '${direction} #${street}, $city, $department';
          addressLatLng = new LatLng(lat, lng);

          refresh!();


        }
      }
    }
  }
  void updateLocation() async {
    try {
      await _determinePosition(); // got current position
      _position = await Geolocator.getLastKnownPosition(); //lat and long
    } catch (e) {
      print("Error: $e");
    }
  }

  Future animateCameraToPosition(double lat, double lng) async {
    GoogleMapController controller = await _mapController.future;

    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(lat, lng),
              zoom: 13,
            bearing: 0
          )
      )
      );
    }
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
