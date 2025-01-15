import 'package:coc/components/button.dart';
import 'package:coc/controllers/case.dart';
import 'package:coc/pages/pictures.dart';
import 'package:coc/pages/register_evidence.dart';
import 'package:coc/pages/scanner.dart';
import 'package:flutter/material.dart';
import 'package:coc/components/case_base_details.dart';
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
              Button(
                title: 'Add evidence',
                icon: Icons.qr_code,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QRScannerPage(
                              onScan: navigateToEvidenceCreate(caseItem))));
                },
              ),
              Button(
                title: "Add media evidence",
                icon: Icons.camera,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PictureTakingPage(caseItem: caseItem)),
                  );
                },
              ),
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
