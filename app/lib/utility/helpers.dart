// Package imports:
import 'package:latlong2/latlong.dart';

LatLng coordinatesFromString(String coords) {
  final List<String> coordList = coords.split(",");
  final double lat = double.parse(coordList[0]);
  final double long = double.parse(coordList[1]);
  return LatLng(lat, long);
}

String coordinatesToString(LatLng coords) {
  return "${coords.latitude},${coords.longitude}";
}

String formatTimestamp(DateTime timestamp) {
  return '${timestamp.hour.toString().padLeft(2, '0')}:'
      '${timestamp.minute.toString().padLeft(2, '0')}:'
      '${timestamp.second.toString().padLeft(2, '0')} '
      '${timestamp.day.toString().padLeft(2, '0')}-'
      '${timestamp.month.toString().padLeft(2, '0')}-'
      '${timestamp.year.toString()}';
}

String? validateField(String? value, String fieldName) {
  if (value == null || value.isEmpty) {
    return 'Please enter $fieldName';
  }
  return null;
}
