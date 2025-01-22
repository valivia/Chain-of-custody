// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:coc/components/listItems/tagged_evidence.dart';
import 'package:coc/controllers/tagged_evidence.dart';

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
              final item = taggedEvidence[index];
              return TaggedEvidenceListItem(taggedEvidenceItem: item);
            },
          ),
        ),
      ],
    );
  }
}
