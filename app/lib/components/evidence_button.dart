// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:coc/controllers/tagged_evidence.dart';
import 'package:coc/pages/evidence_detail.dart';

Widget evidenceButton(BuildContext context, TaggedEvidence taggedEvidenceItem) {
  TextTheme aTextTheme = Theme.of(context).textTheme;
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
            builder: (context) =>
                EvidenceDetailView(evidence: taggedEvidenceItem),
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
              Text("ID: ${taggedEvidenceItem.id}", style: aTextTheme.bodyLarge,),
              Text("Description: ${taggedEvidenceItem.description.toString()}", style: aTextTheme.bodyMedium,),
            ],
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios_rounded),
        ],
      ),
    ),
  );
}
