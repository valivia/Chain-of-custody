import 'package:coc/components/button.dart';
import 'package:coc/controllers/case.dart';
import 'package:coc/pages/pictures.dart';
import 'package:coc/pages/register_evidence.dart';
import 'package:coc/pages/scanner.dart';
import 'package:coc/service/authentication.dart';
import 'package:flutter/material.dart';
import 'package:coc/components/case_base_details.dart';
import 'package:coc/components/lim_case_user_list.dart';
import 'package:coc/components/lim_evidence_list.dart';
import 'package:coc/components/media_evidence.dart';

class CaseDetailView extends StatelessWidget {
  const CaseDetailView({super.key, required this.caseItem});
  final Case caseItem;
  Future<String> get tokenFuture => Authentication.getBearerToken();

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
                        onScan: navigateToEvidenceCreate(caseItem),
                      ),
                    ),
                  );
                },
              ),
              Button(
                title: "Add media evidence",
                icon: Icons.camera,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PictureTakingPage(caseItem: caseItem),
                    ),
                  );
                },
              ),
              buildCaseDetails(caseItem),
              const SizedBox(height: 16),
              limCaseUserList(context, caseItem.users),
              const SizedBox(height: 8),
              limEvidenceList(context, caseItem.taggedEvidence),
              const SizedBox(height: 8),
              FutureBuilder<String>(
                future: tokenFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error loading media evidence');
                  } else {
                    return mediaEvidenceView(
                      mediaEvidence: caseItem.mediaEvidence,
                      token: snapshot.data!,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
