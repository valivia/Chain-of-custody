// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:coc/controllers/tagged_evidence.dart';
import 'package:coc/pages/evidence_detail.dart';

class TaggedEvidenceListItem extends StatelessWidget {
  final TaggedEvidence taggedEvidenceItem;

  const TaggedEvidenceListItem({
    super.key,
    required this.taggedEvidenceItem,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme aTextTheme = Theme.of(context).textTheme;
    return ElevatedButton(
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
          Icon(
            taggedEvidenceItem.containerType.icon,
            color: taggedEvidenceItem.offline ? Colors.orange : Colors.white,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                taggedEvidenceItem.itemType,
                style: aTextTheme.bodyMedium,
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios_rounded),
        ],
      ),
    );
  }
}
