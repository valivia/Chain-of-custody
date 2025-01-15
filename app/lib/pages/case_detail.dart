import 'package:coc/components/button.dart';
import 'package:coc/controllers/case.dart';
import 'package:coc/pages/pictures.dart';
import 'package:coc/pages/register_evidence.dart';
import 'package:coc/pages/scanner.dart';
import 'package:flutter/material.dart';
import 'package:coc/components/case_base_details.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:coc/components/lim_case_user_list.dart';
import 'package:coc/components/lim_evidence_list.dart';
import 'package:coc/components/lim_media_evidence.dart';

class CaseDetailView extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  CaseDetailView({super.key, required this.caseItem});
  final Case caseItem;
  static Future<bool> hasInternetConnection() async {
    return await InternetConnectionChecker().hasConnection;
  }

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
              buildCaseDetails(caseItem),
              const SizedBox(height: 16),
              limCaseUserList(context, caseItem.users),
              const SizedBox(height: 8),
              limEvidenceList(context, caseItem.taggedEvidence),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Media Evidence',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PictureTakingPage(caseItem: caseItem),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    FutureBuilder<bool>(
                      future: hasInternetConnection(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError || !snapshot.data!) {
                          return const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text('No internet connection'),
                          );
                        } else {
                          return limMediaEvidenceView(
                            context: context,
                            mediaEvidence: caseItem.mediaEvidence,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
