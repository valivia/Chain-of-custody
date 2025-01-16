import 'package:coc/controllers/tagged_evidence.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPointer extends StatelessWidget {
  final LatLng location;

  const MapPointer({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: location,
        initialZoom: 15.0,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: const ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: location,
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

class MapPointerBottomSheet extends StatelessWidget {
  final TaggedEvidence evidenceItem;

  const MapPointerBottomSheet({super.key, required this.evidenceItem});

  @override
  Widget build(BuildContext context) {
    final location = evidenceItem.originCoordinates;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Expanded(
              child: MapPointer(location: location),
            ),
            const SizedBox(height: 16),
            Text(
              'Origin location : (${location.latitude}, ${location.longitude})',
              style: const TextStyle(fontSize: 16),
            ),
            
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}