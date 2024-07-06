import 'package:location/location.dart' show Location, PermissionStatus, LocationData;

class LocationService {
  Location location = Location();
  LocationData? _locData;

  Future<void> initialize() async {
    bool _serviceEnabled;
    PermissionStatus _permission;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permission = await location.hasPermission();
    if (_permission == PermissionStatus.denied) {
      _permission = await location.requestPermission();
      if (_permission != PermissionStatus.granted) {
        return;
      }
    }

    _locData = await location.getLocation();
  }

  Future<double?> getLatitude() async {
    if (_locData == null) {
      _locData = await location.getLocation();
    }
    return _locData?.latitude;
  }

  Future<double?> getLongitude() async {
    if (_locData == null) {
      _locData = await location.getLocation();
    }
    return _locData?.longitude;
  }
}
