import 'package:geolocator/geolocator.dart';

class GeoLocatorService {
  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
