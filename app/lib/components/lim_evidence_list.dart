import 'package:coc/components/full_evidence_list.dart';
import 'package:coc/controllers/tagged_evidence.dart';
import 'package:flutter/material.dart';

Widget limEvidenceList(BuildContext context, List<TaggedEvidence> taggedEvidence) {
  // TODO: See if sorting is possible 
  const int displayItemCount = 3;
  final displayedEvidenceItems = taggedEvidence.take(displayItemCount).toList();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Tagged Evidence',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: displayedEvidenceItems.length,
        itemBuilder: (context, index) {
          final taggedEvidenceItem = displayedEvidenceItems[index];
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(10),
            ),
            onPressed: () {},
            child: Row(
              children: [
                const Icon(Icons.person),
                const SizedBox(width: 10),
                Text("${taggedEvidenceItem.id} ${taggedEvidenceItem.description}"),
              ],
            ),
          );
        },
      ),
      if (taggedEvidence.length > displayedEvidenceItems.length)
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(10),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EvidenceList(taggedEvidence: taggedEvidence),
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
    ],
  );
}
