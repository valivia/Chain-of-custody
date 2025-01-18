import 'package:coc/pages/evidence_detail.dart';
import 'package:flutter/material.dart';
import 'package:coc/controllers/tagged_evidence.dart';

Widget evidenceButton(BuildContext context, TaggedEvidence taggedEvidenceItem) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
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
}
