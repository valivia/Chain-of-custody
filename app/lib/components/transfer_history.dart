import 'package:coc/controllers/tagged_evidence.dart';
import 'package:coc/controllers/audit_log.dart' as coc_audit;
import 'package:flutter/material.dart';
import 'package:coc/components/listItems/transfer_history.dart';

class TransferHistoryView extends StatelessWidget {
  const TransferHistoryView({super.key, required this.evidenceItem});
  final TaggedEvidence evidenceItem;

  List<coc_audit.AuditLog> gatherTransfers(List<coc_audit.AuditLog> auditLog) {
    // reversed the list for correct timelines
    return auditLog.where((log) => log.action == coc_audit.Action.transfer).toList().reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    final transferLog = gatherTransfers(evidenceItem.auditLog);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer History page'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemCount: transferLog.length,
        itemBuilder: (context, index) {
          final log = transferLog[index];
          return TransferHistoryListItem(log: log);
        },
      ),
    );
  }
}
