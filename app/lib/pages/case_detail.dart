import 'package:coc/controllers/case.dart';
import 'package:flutter/material.dart';
import 'package:coc/components/case_baseDetails.dart';
import 'package:coc/components/lim_case_user_list.dart';

class CaseDetailViewRemake extends StatelessWidget {
  const CaseDetailViewRemake({super.key, required this.caseItem});
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
              caseUserListRemake(context, caseItem.users),
            ],
          ),
        ),
      ),
    );
    
  }
}