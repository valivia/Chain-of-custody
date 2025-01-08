import 'package:latlong2/latlong.dart';

LatLng coordinatesFromString(String coords) {
  final List<String> coordList = coords.split(",");
  final double lat = double.parse(coordList[0]);
  final double long = double.parse(coordList[1]);
  return LatLng(lat, long);
}