import 'package:flutter/material.dart';
import 'package:coc/controllers/case.dart';
import 'package:coc/components/case_button.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CaseList(caseList: caseList),
      ),
    );
  }
}

class CaseList extends StatelessWidget {
  const CaseList({super.key, required this.caseList});
  final List<Case> caseList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: caseList.length,
            itemBuilder: (context, index) {
              final caseItem = caseList[index];
              return caseButton(context, caseItem);
            },
          ),
        )
      ],
    );
  }
}
