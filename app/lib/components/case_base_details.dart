// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:coc/controllers/case.dart';
import 'package:coc/utility/helpers.dart';

class CaseDetails extends StatelessWidget {
  final Case caseItem;

  const CaseDetails({super.key, required this.caseItem});

  @override
  Widget build(BuildContext context) {
    final createdAt = caseItem.createdAt != null
        ? formatTimestamp(caseItem.createdAt!)
        : 'N/A';
    final updatedAt = caseItem.updatedAt != null
        ? formatTimestamp(caseItem.updatedAt!)
        : 'N/A';
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text("Status: ${caseItem.statusString.toUpperCase()}"),
          const SizedBox(height: 5),
          Text("ID: ${caseItem.id}"),
          const SizedBox(height: 5),
          Text("Created at: $createdAt"),
          const SizedBox(height: 5),
          Text("Updated at: $updatedAt"),
          const SizedBox(height: 8),
          const Text(
            'Description',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(caseItem.description),
        ],
      ),
    );
  }
}
