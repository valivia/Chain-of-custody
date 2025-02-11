// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:coc/components/listItems/transfer_history.dart';
import 'package:coc/controllers/audit_log.dart';
import 'package:coc/pages/lists/full_transfer_history.dart';

class LimTransferHistoryView extends StatelessWidget {
  const LimTransferHistoryView({
    super.key,
    required this.transfers,
    required this.itemCount,
  });

  final List<AuditLog> transfers;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    TextTheme aTextTheme = Theme.of(context).textTheme;
    // Display
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(0),
          itemCount: min(itemCount, transfers.length),
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
            color: aTextTheme.bodyMedium?.color,
          ),
        ),
        // view all
        if (transfers.length > itemCount)
          Column(
            children: [
              Icon(
                Icons.arrow_drop_up_rounded,
                size: 40.0,
                color: aTextTheme.bodyMedium?.color,
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
                            TransferHistoryView(transfers: transfers),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_forward,
                        color: aTextTheme.bodyMedium?.color,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'View All',
                        style: aTextTheme.bodyMedium,
                      ),
                      const Spacer(),
                      Text(
                        "${transfers.length} total",
                        style: aTextTheme.bodyMedium,
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
