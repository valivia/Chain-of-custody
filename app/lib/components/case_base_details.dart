// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:coc/components/key_value.dart';
import 'package:coc/controllers/case.dart';
import 'package:coc/utility/helpers.dart';

class CaseDetails extends StatelessWidget {
  final Case caseItem;

  const CaseDetails({super.key, required this.caseItem});

  @override
  Widget build(BuildContext context) {
    TextTheme aTextTheme = Theme.of(context).textTheme;
    final createdAt = caseItem.createdAt != null
        ? formatTimestamp(caseItem.createdAt!)
        : 'N/A';
    final updatedAt = caseItem.updatedAt != null
        ? formatTimestamp(caseItem.updatedAt!)
        : 'N/A';
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Case details',
            style: aTextTheme.displayMedium,
          ),
          const SizedBox(height: 5),
          KeyValue(
              keyText: "Status", value: caseItem.statusString.toUpperCase()),
          const SizedBox(height: 5),
          KeyValue(keyText: "ID", value: caseItem.id),
          const SizedBox(height: 5),
          KeyValue(keyText: "Created At", value: createdAt),
          const SizedBox(height: 5),
          KeyValue(keyText: "Updated At", value: updatedAt),
          const SizedBox(height: 8),
          Text(
            'Description',
            style: aTextTheme.displaySmall,
          ),
          const SizedBox(height: 5),
          Text(caseItem.description),
        ],
      ),
    );
  }
}
