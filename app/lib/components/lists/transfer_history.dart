// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:coc/controllers/tagged_evidence.dart';
import 'package:coc/controllers/audit_log.dart' as coc_audit;
import 'package:coc/components/listItems/transfer_history.dart';
import 'package:coc/pages/lists/full_transfer_history.dart';

class LimTransferHistoryView extends StatelessWidget {
  const LimTransferHistoryView({
    super.key,
    required this.evidenceItem,
    required this.itemCount,
  });

  final TaggedEvidence evidenceItem;
  final int itemCount;

  List<coc_audit.AuditLog> gatherTransfers(List<coc_audit.AuditLog> auditLog) {
    // reversed the list for correct timelines
    return auditLog
        .where((log) => log.action == coc_audit.Action.transfer)
        .toList()
        .reversed
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final transferLog = gatherTransfers(evidenceItem.auditLog);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(0),
          itemCount: min(itemCount, transferLog.length),
          itemBuilder: (context, index) {
            final log = transferLog[index];
            return TransferHistoryListItem(log: log);
          },
          separatorBuilder: (context, index) => const Icon(
            Icons.arrow_drop_up_rounded,
            size: 40.0,
          ),
        ),
        // view all
        if (transferLog.length > itemCount)
          Column(
            children: [
              const Icon(
                Icons.arrow_drop_up_rounded,
                size: 40.0,
              ),
              Padding(
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
                            TransferHistoryView(transferLog: transferLog),
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
                        "${transferLog.length} total",
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
