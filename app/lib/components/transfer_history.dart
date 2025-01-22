import 'package:coc/controllers/tagged_evidence.dart';
import 'package:coc/controllers/audit_log.dart' as coc_audit;
import 'package:flutter/material.dart';

class TransferHistoryView extends StatelessWidget {
  const TransferHistoryView({super.key, required this.evidenceItem});
  final TaggedEvidence evidenceItem;

  List<coc_audit.AuditLog> gatherTransfers(List<coc_audit.AuditLog> auditLog) {
    return auditLog.where((log) => log.action == coc_audit.Action.transfer).toList();
  }

  @override
  Widget build(BuildContext context) {
    final transferLog = gatherTransfers(evidenceItem.auditLog);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer History page'),
      ),
      body: ListView.builder(
        itemCount: transferLog.length,
        itemBuilder: (context, index) {
          final log = transferLog.elementAt(index);
          return ListTile(
            subtitle: Text('Date: ${log.id}, User: ${log.userId}, location: ${log.location}'),
          );
        },
      ),
    );
  }
}
