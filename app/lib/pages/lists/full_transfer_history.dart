import 'package:flutter/material.dart';
import 'package:coc/components/listItems/transfer_history.dart';

class TransferHistoryView extends StatelessWidget {
  const TransferHistoryView({super.key, required this.transferLog});
  final List transferLog;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer History page'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemCount: transferLog.length,
        itemBuilder: (context, index) {
          final log = transferLog[index];
          return TransferHistoryListItem(log: log);
        },
        separatorBuilder: (context, index) => const Icon(
          Icons.arrow_drop_up_rounded,
          size: 40.0,
        ),
      ),
    );
  }
}
