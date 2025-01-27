// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:watch_it/watch_it.dart';

// Project imports:
import 'package:coc/components/listItems/case.dart';
import 'package:coc/pages/lists/full_case_list.dart';
import 'package:coc/service/data.dart';

class LimCaseList extends WatchingWidget {
  const LimCaseList({super.key, required this.itemCount});
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final caseList =
        watchPropertyValue((DataService dataService) => dataService.cases);

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cases',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(0),
                itemCount: min(itemCount, caseList.length),
                itemBuilder: (context, index) {
                  final caseItem = caseList[index];
                  return CaseListItem(caseItem: caseItem);
                },
              ),
              if (caseList.length > itemCount)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CaseListView(caseList: caseList),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_forward),
                      const SizedBox(width: 10),
                      Text('View ${caseList.length - itemCount} more cases'),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
