// Flutter imports:
import 'package:coc/service/data.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:coc/controllers/case.dart';
import 'package:coc/pages/case_detail.dart';
import 'package:watch_it/watch_it.dart';

class CaseListItem extends StatelessWidget {
  final Case caseItem;

  const CaseListItem({
    super.key,
    required this.caseItem,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(8),
        ),
        onPressed: () {
          di<DataService>().currentCase = caseItem;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CaseDetailView(),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  caseItem.title,
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  caseItem.id,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
