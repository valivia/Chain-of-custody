// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:coc/components/listItems/tagged_evidence.dart';
import 'package:coc/controllers/tagged_evidence.dart';
import 'package:coc/pages/lists/full_evidence_list.dart';

class LimTaggedEvidenceList extends StatelessWidget {
  const LimTaggedEvidenceList({
    super.key,
    required this.itemCount,
    required this.taggedEvidence,
  });

  final int itemCount;
  final List<TaggedEvidence> taggedEvidence;

  @override
  Widget build(BuildContext context) {
    TextTheme aTextTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // List
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(0),
          itemCount: min(itemCount, taggedEvidence.length),
          itemBuilder: (context, index) {
            final item = taggedEvidence[index];
            return TaggedEvidenceListItem(taggedEvidenceItem: item);
          },
        ),

        // View All Button
        if (taggedEvidence.length > itemCount)
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 4.0), // Add vertical padding
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(10),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EvidenceListView(taggedEvidence: taggedEvidence),
                  ),
                );
              },
              child: Row(
                children: [
                  const Icon(Icons.arrow_forward),
                  const SizedBox(width: 10),
                  Text(
                    'View All',
                    style: aTextTheme.bodyMedium,
                  ),
                  const Spacer(),
                  Text(
                    "${taggedEvidence.length} total",
                    style: aTextTheme.bodyMedium,
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
