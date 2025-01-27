// Flutter imports:
import 'package:coc/service/data.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// Project imports:
import 'package:coc/utility/helpers.dart';
import 'package:watch_it/watch_it.dart';

class MapPointer extends StatelessWidget {
  final LatLng location;

  const MapPointer({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
          initialCenter: location,
          initialZoom: 15.0,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all,
          ),
          cameraConstraint: CameraConstraint.containCenter(
              bounds: LatLngBounds(location, location))),
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
  final Map locationData;
  final String title;

  const MapPointerBottomSheet(
      {super.key, required this.locationData, required this.title});

  @override
  Widget build(BuildContext context) {
    final location = locationData['location'];
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: MapPointer(location: location),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.person, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  di<DataService>()
                          .currentCase
                          ?.getUser(locationData['userId'])
                          ?.fullName ??
                      'Unknown',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.access_time_outlined, color: Colors.white),
                const SizedBox(width: 8),
                Text(formatTimestamp(locationData["createdAt"])),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  '${location.latitude}, ${location.longitude}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
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
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
