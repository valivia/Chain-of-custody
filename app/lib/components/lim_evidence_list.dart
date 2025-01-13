import 'package:coc/components/full_evidence_list.dart';
import 'package:coc/controllers/tagged_evidence.dart';
import 'package:flutter/material.dart';
import 'package:coc/pages/evidence_detail.dart';

Widget limEvidenceList(BuildContext context, List<TaggedEvidence> taggedEvidence) {
  // TODO: See if sorting is possible 
  const int displayItemCount = 3;
  final displayedEvidenceItems = taggedEvidence.take(displayItemCount).toList();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
       Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tagged Evidence',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Total: ${taggedEvidence.length}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: displayedEvidenceItems.length,
        itemBuilder: (context, index) {
          final taggedEvidenceItem = displayedEvidenceItems[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0), // Add vertical padding
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(10),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EvidenceDetailView(evidenceItem: taggedEvidenceItem),
                  ),
                );
              },
              child: Row(
                children: [
                  const Icon(Icons.info),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text("ID: ${taggedEvidenceItem.id}"),
                    Text("Description: ${taggedEvidenceItem.description.toString()}"),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios_rounded),
                ],
              ),
            ),
          );
        },
      ),
      if (taggedEvidence.length > displayedEvidenceItems.length)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0), // Add vertical padding
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(10),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EvidenceListView(taggedEvidence: taggedEvidence),
                ),
              );
            },
            child: const Row(
              children: [
                Icon(Icons.arrow_forward),
                SizedBox(width: 10),
                Text('View All'),
              ],
            ),
          ),
        ),
    ],
  );
}
