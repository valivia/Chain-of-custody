import 'package:coc/controllers/audit_log.dart' as coc_audit;
import 'package:coc/utility/helpers.dart';
import 'package:flutter/material.dart';
import 'package:coc/components/location_display.dart';


class TransferHistoryListItem extends StatelessWidget {
  final coc_audit.AuditLog log;
  final List<Map<String, dynamic>> locationData;

  TransferHistoryListItem({super.key, required this.log})
      : locationData = [
          {
            'createdAt': log.createdAt,
            'userId': log.userId,
            'location': log.location,
          },
        ];

  @override
  Widget build(BuildContext context) {
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
              locationData: locationData[0],
              title: "Transfer",
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
