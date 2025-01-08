import 'package:coc/controllers/case.dart';
import 'package:flutter/material.dart';

class CaseDetailView extends StatelessWidget {
  const CaseDetailView({super.key, required this.caseItem});
  final Case caseItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CASE ID: ${caseItem.id}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Case Title: ${caseItem.title}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ]),
      ),
    );
  }
}
