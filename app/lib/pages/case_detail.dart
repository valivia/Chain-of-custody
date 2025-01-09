import 'package:coc/components/user_list.dart';
import 'package:coc/controllers/case.dart';
import 'package:flutter/material.dart';
import 'package:coc/components/evidence_list.dart';
import 'package:coc/components/case_baseDetails.dart';

class CaseDetailView extends StatelessWidget {
  const CaseDetailView({super.key, required this.caseItem});
  final Case caseItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '${caseItem.title} \n${caseItem.id}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildCaseDetails(caseItem),
            // Users on case
            Expanded(
              child: CaseUserListView(users: caseItem.users),
            ),
            // Tagged evidence to case
            Expanded(
              child: EvidenceListView(taggedEvidence: caseItem.taggedEvidence),
            ),


          ],
        ),
      ),
    );
  }
}
