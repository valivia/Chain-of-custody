// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:watch_it/watch_it.dart';

// Project imports:
import 'package:coc/components/listItems/case.dart';
import 'package:coc/controllers/case.dart';
import 'package:coc/service/data.dart';

class CaseListView extends StatelessWidget {
  const CaseListView({super.key, required this.caseList});
  final List<Case> caseList;

  @override
  Widget build(BuildContext context) {
    TextTheme aTextTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Cases", style: aTextTheme.headlineMedium,),
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
              return CaseListItem(caseItem: caseItem);
            },
          ),
        )
      ],
    );
  }
}
