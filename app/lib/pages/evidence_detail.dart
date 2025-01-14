import 'package:coc/controllers/tagged_evidence.dart';
import 'package:flutter/material.dart';
import 'package:coc/service/edit_formats.dart';
import 'package:coc/components/map_pointer.dart';
import 'package:coc/components/media_evidence.dart';

class EvidenceDetailView extends StatelessWidget {
  const EvidenceDetailView({super.key, required this.evidenceItem});
  final TaggedEvidence evidenceItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          evidenceItem.id,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Case ID: ${evidenceItem.caseId}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Evidence ID: ${evidenceItem.id}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Type: ${evidenceItem.itemType}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Description: ${evidenceItem.description}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Entry created at: ${EditFormats().formatTimestamp(evidenceItem.madeOn).toString()}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Entry updated at: ${EditFormats().formatTimestamp(evidenceItem.updatedAt).toString()}',
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
                              Text('Origin location description: ${evidenceItem.description}'),
                              const SizedBox(height: 10),
                              Text('Origin location coordinates: ${evidenceItem.originCoordinates.latitude}, ${evidenceItem.originCoordinates.longitude}'),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                height: 200,
                                child: MapPointer(
                                  latitude: evidenceItem.originCoordinates.latitude,
                                  longitude: evidenceItem.originCoordinates.longitude,
                                ),
                              ),
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
          ],
        ),
      ),
    );
  }
}
