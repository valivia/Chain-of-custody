// Dart imports:
import 'dart:async';
import 'dart:developer';

// Package imports:
import 'package:geolocator/geolocator.dart';

class LocationService {
  Position? _currentPosition;
  Timer? _locationUpdateTimer;

  LocationService() {
    startPeriodicLocationUpdates(LocationAccuracy.bestForNavigation);
  }

  /// Requests location permissions and checks if location services are enabled.
  Future<bool> _handlePermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      log("Location services are disabled.");
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
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

    // Try to get the last known position first
    Position? lastKnownPosition = await Geolocator.getLastKnownPosition();
    if (lastKnownPosition != null) {
      _currentPosition = lastKnownPosition;
      _startPeriodicLocationUpdates(desiredAccuracy);
      return lastKnownPosition;
    }

    // If no last known position, get the current position with a timeout
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: desiredAccuracy,
        timeLimit: const Duration(seconds: 10), // Set a timeout
      ),
    );
    _currentPosition = position;
    _startPeriodicLocationUpdates(desiredAccuracy);
    return position;
  }

  void _startPeriodicLocationUpdates(LocationAccuracy desiredAccuracy) {
    _locationUpdateTimer?.cancel(); // Cancel any existing timer

    _locationUpdateTimer =
        Timer.periodic(const Duration(seconds: 60), (timer) async {
      try {
        Position position = await Geolocator.getCurrentPosition(
          locationSettings: LocationSettings(
            accuracy: desiredAccuracy,
            timeLimit: const Duration(seconds: 10), // Set a timeout
          ),
        );
        _currentPosition = position;
        log('Location updated: ${position.latitude}, ${position.longitude}');
      } catch (e) {
        log('Error updating location: $e');
      }
    });
  }

  void startPeriodicLocationUpdates(LocationAccuracy desiredAccuracy) async {
    bool hasPermission = await _handlePermissions();
    if (hasPermission) {
      _startPeriodicLocationUpdates(desiredAccuracy);
    }
  }

  Position? get currentPosition => _currentPosition;

  void dispose() {
    _locationUpdateTimer?.cancel();
  }
}
