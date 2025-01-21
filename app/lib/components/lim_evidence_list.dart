// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:coc/components/evidence_button.dart';
import 'package:coc/components/full_evidence_list.dart';
import 'package:coc/controllers/tagged_evidence.dart';

Widget limEvidenceList(
  BuildContext context,
  List<TaggedEvidence> taggedEvidence,
) {
  const int displayItemCount = 3;
  final displayedEvidenceItems = taggedEvidence.take(displayItemCount).toList();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: displayedEvidenceItems.length,
        itemBuilder: (context, index) {
          final taggedEvidenceItem = displayedEvidenceItems[index];
          return evidenceButton(context, taggedEvidenceItem);
        },
      ),
      if (taggedEvidence.length > displayedEvidenceItems.length)
        Padding(
          padding:
              const EdgeInsets.symmetric(vertical: 4.0), // Add vertical padding
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
                const Text('View All'),
                const Spacer(),
                Text(
                  "${taggedEvidence.length} total",
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
    ],
  );
}
