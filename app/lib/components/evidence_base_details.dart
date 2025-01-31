// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:coc/components/key_value.dart';
import 'package:coc/controllers/tagged_evidence.dart';
import 'package:coc/utility/helpers.dart';

class EvidenceDetails extends StatelessWidget {
  final TaggedEvidence evidence;

  const EvidenceDetails({super.key, required this.evidence});

  @override
  Widget build(BuildContext context) {
    final createdAt = evidence.createdAt != null
        ? formatTimestamp(evidence.createdAt!)
        : 'N/A';
    final updatedAt = evidence.updatedAt != null
        ? formatTimestamp(evidence.updatedAt!)
        : 'N/A';
    // View
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Case details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          KeyValue(keyText: "Container", value: evidence.containerType.name),
          const SizedBox(height: 5),
          KeyValue(keyText: "Item Type", value: evidence.itemType),
          const SizedBox(height: 5),
          KeyValue(keyText: "id", value: evidence.id),
          const SizedBox(height: 5),
          KeyValue(keyText: "Created At", value: createdAt),
          const SizedBox(height: 5),
          KeyValue(keyText: "Updated At", value: updatedAt),

          // Description
          if (evidence.description != null &&
              evidence.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text(
              'Description',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(evidence.description!),
          ],

          // Location
          const SizedBox(height: 8),
          const Text(
            'Location Description',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(evidence.originLocationDescription),
        ],
      ),
    );
  }
}
