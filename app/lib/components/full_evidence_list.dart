import 'dart:developer';
import 'package:coc/controllers/tagged_evidence.dart';
import 'package:flutter/material.dart';
import 'package:coc/pages/evidence_detail.dart';

class EvidenceListView extends StatelessWidget {
  const EvidenceListView({super.key, required this.taggedEvidence});
  final List<TaggedEvidence> taggedEvidence;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Evidence List'),
            Text(
              'Case ID: ${taggedEvidence.first.caseId}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
        Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: EvidenceList(taggedEvidence: taggedEvidence),
      ),
    );
  }
}

class EvidenceList extends StatelessWidget {
  const EvidenceList({super.key, required this.taggedEvidence});
  final List<TaggedEvidence> taggedEvidence;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: taggedEvidence.length,
            itemBuilder: (context, index) {
              final evidence = taggedEvidence[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("ID: ${evidence.id}"),
                          Text("Description: ${evidence.description.toString()}"),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios_rounded),
                    ],
                  ),
                  onPressed: () {
                    log('Clicked on ${evidence.id}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EvidenceDetailView(evidenceItem: evidence),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
