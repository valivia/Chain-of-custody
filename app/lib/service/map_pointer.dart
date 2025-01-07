import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPointer extends StatelessWidget {
  final double latitude;
  final double longitude;

  MapPointer({required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(latitude, longitude),
        initialZoom: 5.0,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers:  [
            Marker(
              point: LatLng(latitude, longitude),
              height: 20,
              width: 20, 
              child: const Icon(Icons.location_on, color: Colors.red),              
            ),
          ],
        ),
      ],
    );
  }
}