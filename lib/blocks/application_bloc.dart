import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jobheeseller/services/geolocator_service.dart';

class ApplicationBloc with ChangeNotifier {
  final geoLocator = GeoLocatorService();

  //variables
  Position currentLocation;

  ApplicationBloc() {
    //setCurrentLocation();
  }

  getCurrentLocation() async {
    currentLocation = await geoLocator.getCurrentPosition();
    notifyListeners();
  }
}
