import 'dart:math';

import 'package:flutter/material.dart';
import 'package:coc/controllers/case.dart';
import 'package:coc/pages/case_detail.dart';
import 'package:coc/components/full_case_list.dart';

class LimCaseList extends StatelessWidget {
  const LimCaseList(
      {super.key,
      required this.caseList,
      required this.displayedCaseItemsCount});

  final List<Case> caseList;
  final int displayedCaseItemsCount;

  @override
  Widget build(BuildContext context) {
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
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(0),
                itemCount: min(displayedCaseItemsCount, caseList.length),
                itemBuilder: (context, index) {
                  final caseItem = caseList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(8),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CaseDetailView(caseItem: caseItem),
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
                },
              ),
              if (caseList.length > displayedCaseItemsCount)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CaseListView(caseList: caseList),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_forward),
                      const SizedBox(width: 10),
                      Text(
                          'View ${caseList.length - displayedCaseItemsCount} more cases'),
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
