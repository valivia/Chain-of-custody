// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:coc/components/lists/transfer_history.dart';
import 'package:coc/components/location_display.dart';
import 'package:coc/controllers/tagged_evidence.dart';
import 'package:coc/utility/helpers.dart';

class EvidenceDetailView extends StatelessWidget {
  final TaggedEvidence evidenceItem;
  final List<Map<String, dynamic>> locationData;

  EvidenceDetailView({super.key, required this.evidenceItem})
      : locationData = [
          {
            'createdAt': evidenceItem.createdAt,
            'userId': evidenceItem.userId,
            'location': evidenceItem.originCoordinates,
          },
        ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          evidenceItem.id,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Case ID: ${evidenceItem.caseId}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                'Entry created at: ${formatTimestamp(evidenceItem.madeOn)}',
                style: const TextStyle(fontSize: 16),
              ),
              if (evidenceItem.updatedAt != null) ...[
                const SizedBox(height: 10),
                Text(
                  'Entry updated at: ${formatTimestamp(evidenceItem.updatedAt!)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      showDragHandle: true,
                      context: context,
                      builder: (BuildContext context) {
                        return MapPointerBottomSheet(
                            locationData: locationData[0], title: "Origin");
                      },
                    );
                  },
                  child: const Text('Origin location'),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Transfers',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    LimTransferHistoryView(
                        transfers: evidenceItem.transfers, itemCount: 2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
