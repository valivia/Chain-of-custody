// Dart imports:
import 'dart:developer';

// Package imports:
import 'package:geolocator/geolocator.dart';

class LocationService {
  // Singleton pattern to provide a single instance
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  /// Requests location permissions and checks if location services are enabled.
  Future<bool> _handlePermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      log("Location services are disabled.");
      return false;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request location permissions
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log("Location permissions are denied.");
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied
      log("Location permissions are permanently denied.");
      return false;
    }

    return true; // All permissions granted
  }

  /// Fetches the current position of the device.
  Future<Position> getCurrentLocation(
      {required LocationAccuracy desiredAccuracy}) async {
    bool hasPermission = await _handlePermissions();
    if (!hasPermission) return Future.error("Location permissions denied.");
    Position _defaultPosition = Position(
      latitude: 0.0,
      longitude: 0.0,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );
    return _defaultPosition;
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: desiredAccuracy,
      ),
    );
    return position;
  }
}
