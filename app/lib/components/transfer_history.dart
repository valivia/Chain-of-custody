import 'package:coc/controllers/tagged_evidence.dart';
import 'package:coc/controllers/audit_log.dart' as coc_audit;
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class TransferHistoryView extends StatelessWidget {
  TransferHistoryView({super.key, required this.evidenceItem});
  final TaggedEvidence evidenceItem;
  late List<coc_audit.AuditLog> auditLog;

  gatherAuditLog() {
    return evidenceItem.auditLogs;
  }


  List<coc_audit.AuditLog> gatherTransfers(auditLog){
    return auditLog.where((log) => log.action == coc_audit.Action.transfer).toList();
  }



  @override
  Widget build(BuildContext context) {
    auditLog = gatherAuditLog(); 
    final tranferLog = gatherTransfers(auditLog);


    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer History page'),
      ),
      body: ListView.builder(
        itemCount: tranferLog.length,
        itemBuilder: (context, index) {
          final log = tranferLog.elementAt(index);
          return ListTile(
          subtitle: Text('Date: ${log.id}, User: ${log.userId}, location: ${log.location}'),
          );
        },
      ),
    );
  }
}