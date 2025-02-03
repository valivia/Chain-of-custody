// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:watch_it/watch_it.dart';

// Project imports:
import 'package:coc/components/location_display.dart';
import 'package:coc/controllers/audit_log.dart' as coc_audit;
import 'package:coc/service/data.dart';
import 'package:coc/utility/helpers.dart';

class TransferHistoryListItem extends StatelessWidget {
  final coc_audit.AuditLog? previousLog;
  final coc_audit.AuditLog log;
  final List<Map<String, dynamic>> locationData;

  TransferHistoryListItem({super.key, required this.log, this.previousLog})
      : locationData = [
          {
            'createdAt': log.createdAt,
            'userId': log.userId,
            'location': log.location,
          },
        ];

  @override
  Widget build(BuildContext context) {
    TextTheme aTextTheme = Theme.of(context).textTheme;
    final currentCaseUser = di<DataService>().currentCase?.getUser(log.userId);
    final previousCaseUser = previousLog?.userId != null
        ? di<DataService>().currentCase?.getUser(previousLog!.userId)
        : null;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(10),
      ),
      onPressed: () {
        showModalBottomSheet(
          showDragHandle: true,
          context: context,
          builder: (BuildContext context) {
            return MapPointerBottomSheet(
              title: "Transfer",
              userId: log.userId,
              createdAt: log.createdAt,
              location: log.location!,
            );
          },
        );
      },
      child: Row(
        children: [
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (previousCaseUser != null) ...[
                    Text(
                      previousCaseUser.firstName, 
                      style: aTextTheme.bodyMedium,
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_sharp,
                      color: aTextTheme.bodyMedium?.color,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    currentCaseUser?.firstName ?? "Unknown", 
                    style: aTextTheme.bodyMedium,
                    ),
                ],
              ),
              Text(
                formatTimestamp(log.createdAt),
                style: TextStyle(
                  fontSize: 12, 
                  color: aTextTheme.bodyMedium?.color,
                  ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
