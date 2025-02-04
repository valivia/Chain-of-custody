// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:watch_it/watch_it.dart';

// Project imports:
import 'package:coc/service/data.dart';
import 'package:coc/utility/helpers.dart';
// import 'package:coc/service/edit_formats.dart';
// import 'package:coc/controllers/case.dart';

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
          bounds: LatLngBounds(location, location),
        ),
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
  final String title;
  final String userId;
  final DateTime createdAt;
  final LatLng location;

  const MapPointerBottomSheet({
    super.key,
    required this.title,
    required this.userId,
    required this.createdAt,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme aTextTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(Icons.close, color: aTextTheme.displayLarge?.color),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          title,
          style: aTextTheme.displayLarge,
        ),
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
                Icon(Icons.person, color: aTextTheme.displayLarge?.color),
                const SizedBox(width: 8),
                Text(
                  di<DataService>().currentCase?.getUser(userId)?.fullName ??
                      'Unknown',
                  style: TextStyle(
                    fontSize: aTextTheme.displaySmall?.fontSize,
                    color: aTextTheme.displaySmall?.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.access_time_outlined,
                    color: aTextTheme.displayLarge?.color),
                const SizedBox(width: 8),
                Text(
                  formatTimestamp(createdAt),
                  style: aTextTheme.displaySmall,
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.location_on, color: aTextTheme.displayLarge?.color),
                const SizedBox(width: 8),
                Text(
                  '${location.latitude}, ${location.longitude}',
                  style: aTextTheme.displaySmall,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close', style: aTextTheme.bodyLarge),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
