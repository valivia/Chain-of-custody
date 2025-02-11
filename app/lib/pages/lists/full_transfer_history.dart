// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:coc/components/listItems/transfer_history.dart';
import 'package:coc/controllers/audit_log.dart';

class TransferHistoryView extends StatelessWidget {
  const TransferHistoryView({super.key, required this.transfers});
  final List<AuditLog> transfers;

  @override
  Widget build(BuildContext context) {
    TextTheme aTextTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Transfer History page',
          style: aTextTheme.headlineMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          itemCount: transfers.length,
          itemBuilder: (context, index) {
            final log = transfers[index];
            final previousLog =
                index + 1 < transfers.length ? transfers[index + 1] : null;
            return TransferHistoryListItem(
              log: log,
              previousLog: previousLog,
            );
          },
          separatorBuilder: (context, index) => Icon(
            Icons.arrow_drop_up_rounded,
            size: 40.0,
            color: aTextTheme.displayLarge?.color,
          ),
        ),
      ),
    );
  }
}
