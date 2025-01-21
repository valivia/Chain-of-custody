// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:watch_it/watch_it.dart';

// Project imports:
import 'package:coc/controllers/case.dart';
import 'package:coc/pages/case_detail.dart';
import 'package:coc/service/data.dart';

class CaseListView extends StatelessWidget {
  const CaseListView({super.key, required this.caseList});
  final List<Case> caseList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cases"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: CaseList(),
      ),
    );
  }
}

class CaseList extends WatchingWidget {
  const CaseList({super.key});

  @override
  Widget build(BuildContext context) {
    final caseList =
        watchPropertyValue((DataService dataService) => dataService.cases);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: caseList.length,
            itemBuilder: (context, index) {
              final caseItem = caseList[index];
              return Padding(
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
                          Text(caseItem.title,
                              style: const TextStyle(fontSize: 16)),
                          Text(caseItem.id,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w300)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
