import 'package:coc/controllers/case.dart';
import 'package:flutter/material.dart';
import 'package:coc/components/evidence_list.dart';
import 'package:coc/service/edit_formats.dart';

class CaseDetailView extends StatelessWidget {
  const CaseDetailView({super.key, required this.caseItem});
  final Case caseItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '${caseItem.title} \n${caseItem.id}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Case Title: ${caseItem.title}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Case details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text("Case status: ${caseItem.caseStatusString.toUpperCase()}"),
            const SizedBox(height: 5),
            Text("Case description: \n${caseItem.description}"),
            const SizedBox(height: 5),
            Text("Created at: ${EditFormats().formatTimestamp(caseItem.createdAt).toString()}"),
            const SizedBox(height: 5),
            Text("Updated at: ${EditFormats().formatTimestamp(caseItem.updatedAt).toString()}"),
            
            // Tagged evidence to case
            const SizedBox(height: 16),
            Expanded(
              child: EvidenceListView(taggedEvidence: caseItem.taggedEvidence),
            )
          ],
        ),
      ),
    );
  }
}
