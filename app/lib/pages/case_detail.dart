// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:internet_connection_checker/internet_connection_checker.dart';

// Project imports:
import 'package:coc/components/button.dart';
import 'package:coc/components/case_base_details.dart';
import 'package:coc/components/lists/lim_case_user_list.dart';
import 'package:coc/components/lists/lim_evidence_list.dart';
import 'package:coc/components/lists/media_evidence.dart';
import 'package:coc/controllers/case.dart';
import 'package:coc/pages/forms/register_evidence.dart';
import 'package:coc/pages/pictures.dart';
import 'package:coc/pages/scanner.dart';

class CaseDetailView extends StatelessWidget {
  const CaseDetailView({super.key, required this.caseItem});
  final Case caseItem;

  static Future<bool> hasInternetConnection() async {
    return await InternetConnectionChecker().hasConnection;
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Case: ${caseItem.title}", textAlign: TextAlign.center),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
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
              const SizedBox(height: 8),
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
              const SizedBox(height: 32),
              CaseDetails(caseItem: caseItem),
              const SizedBox(height: 10),
              // Handler/caseUser container
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
                            'Handlers',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    LimCaseUserList(itemCount: 3, caseUsers: caseItem.users),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Evidence container
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
                            'Evidence',
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
                                builder: (context) => QRScannerPage(
                                  onScan: navigateToEvidenceCreate(caseItem),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    LimTaggedEvidenceList(
                      taggedEvidence: caseItem.taggedEvidence,
                      itemCount: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Media Container
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
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
                          return LimMediaEvidenceList(
                            mediaEvidence: caseItem.mediaEvidence,
                            itemCount: 4,
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
