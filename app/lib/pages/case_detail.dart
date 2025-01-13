import 'package:coc/controllers/case.dart';
import 'package:flutter/material.dart';
import 'package:coc/components/case_baseDetails.dart';
import 'package:coc/components/lim_case_user_list.dart';
import 'package:coc/components/lim_evidence_list.dart';

class CaseDetailView extends StatelessWidget {
  const CaseDetailView({super.key, required this.caseItem});
  final Case caseItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(caseItem.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildCaseDetails(caseItem),
              const SizedBox(height: 16),
              limCaseUserList(context, caseItem.users),
              const SizedBox(height: 8),
              limEvidenceList(context, caseItem.taggedEvidence)
            ],
          ),
        ),
      ),
    );
    
  }
}