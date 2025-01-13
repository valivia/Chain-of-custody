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
      body: EvidenceList(taggedEvidence: taggedEvidence),
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
      const Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
        'Tagged evidence',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Expanded(
        child: ListView.builder(
        itemCount: taggedEvidence.length,
        itemBuilder: (context, index) {
          final evidence = taggedEvidence[index];
          return ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(10),
          ),
          onPressed: () {
            log('Clicked on ${evidence.id}');
            Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                EvidenceDetailView(evidenceItem: evidence),
            ),
            );
          },
          child: Text("ID: ${evidence.id}"),
          );
        },
        ),
      ),
      ],
    );
  }
}
