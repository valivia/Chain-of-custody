import 'package:coc/components/evidence_button.dart';
import 'package:coc/controllers/tagged_evidence.dart';
import 'package:flutter/material.dart';

class EvidenceListView extends StatelessWidget {
  const EvidenceListView({super.key, required this.taggedEvidence});
  final List<TaggedEvidence> taggedEvidence;

  @override
  Widget build(BuildContext context) {
    TextTheme aTextTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Evidence List', style: aTextTheme.headlineMedium,),
            Text(
              'Case ID: ${taggedEvidence.first.caseId}',
              style: aTextTheme.bodySmall,
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
              return evidenceButton(context, evidence);
            },
          ),
        ),
      ],
    );
  }
}
