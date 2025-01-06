import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:coc/service/evidence.dart';
import 'package:coc/service/edit_formats.dart';

class EvidenceDetailView extends StatelessWidget {
  const EvidenceDetailView({super.key, required this.evidenceItem});
  final Evidence evidenceItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          evidenceItem.evidenceID,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Case ID: [Case ID]',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Evidence ID: ${evidenceItem.evidenceID}',
              style: const TextStyle(fontSize: 16),
            ),  
            const SizedBox(height: 10),
            Text(
              'Type: ${evidenceItem.evidenceType}',
              style: const TextStyle(fontSize: 16),
            ),   
            const SizedBox(height: 10),
            Text(
              'Description: ${evidenceItem.evidenceDescription}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Entry created at: ${EditFormats().formatTimestamp(evidenceItem.evidenceCreatedAt).toString()}',
              style: const TextStyle(fontSize: 16),
            ),const SizedBox(height: 10),
            Text(
              'Entry updated at: ${EditFormats().formatTimestamp(evidenceItem.evidenceUpdatedAt).toString()}',
              style: const TextStyle(fontSize: 16),
            ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
            onPressed: () {
              showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                title: const Text('Location info'),
                content: SingleChildScrollView(
                  child: ListBody(
                  children: <Widget>[
                    Text('Origin location description: ${evidenceItem.evidenceOriginDescription}'),
                    const SizedBox(height: 10),
                    Text('Origin location coordinates: ${evidenceItem.evidenceOriginCoords}'),
                    const SizedBox(height: 10),
                  // TODO: Add map display
                  ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  ),
                ],
                );
              },
              );
            },
            child: const Text('Origin location'),
            ),
          ),
          // TODO: Add transfer history 
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
            onPressed: () {
              showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                title: const Text('Transfer history'),
                content: const SingleChildScrollView(
                  child: ListBody(
                  children: <Widget>[
                    Text('Transfer history to be build'),
                  ],
                  // add widget with map display
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  ),
                ],
                );
              },
              );
            },
            child: const Text('Transfer History'),
            ),
          ),
          // TODO: add media
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
            onPressed: () {
              showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                title: const Text('Media'),
                content: const SingleChildScrollView(
                  child: ListBody(
                  children: <Widget>[
                    Text('Media display to be build')
                  ],
                  // TODO: Add media
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  ),
                ],
                );
              },
              );
            },
            child: const Text('Media'),
            ),
          ),
          ],
        ),
      ),
    );
  }
}
