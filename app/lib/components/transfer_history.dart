import 'package:coc/controllers/tagged_evidence.dart';
import 'package:coc/controllers/audit_log.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class TransferHistoryView extends StatelessWidget {
  TransferHistoryView({super.key, required this.evidenceItem});
  final TaggedEvidence evidenceItem;
  late List<AuditLog> auditLog;

  gatherAuditLog() {
    return evidenceItem.auditLogs;
  }




  @override
  Widget build(BuildContext context) {
    auditLog = gatherAuditLog(); 


    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer History page'),
      ),
      body: ListView.builder(
        itemCount: auditLog.length,
        itemBuilder: (context, index) {
          final log = auditLog.elementAt(index);
          return ListTile(
          subtitle: Text('Date: ${log.id}, User: ${log.userId}, Action: ${log.action}'),
          );
        },
      ),
    );
  }
}