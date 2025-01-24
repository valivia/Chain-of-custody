import 'package:coc/controllers/audit_log.dart' as coc_audit;
import 'package:coc/utility/helpers.dart';
import 'package:flutter/material.dart';

class TransferHistoryListItem extends StatelessWidget {
  const TransferHistoryListItem({
    super.key,
    required this.log,
  });

  final coc_audit.AuditLog log;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(10),
      ),
      onPressed: () {
        
      },
      child: Row(
        children: [
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Transfer"),
                Row(
                children: [
                  Text(log.id),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_right),
                  const SizedBox(width: 4),
                  Text(log.userId),
                ],
                ),
              Text(formatTimestamp(log.createdAt)),
            ],
          ),
        ],
      ),
    );
  }
}
