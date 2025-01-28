// Flutter imports:
import 'package:coc/pages/transfer_evidence.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:watch_it/watch_it.dart';

// Project imports:
import 'package:coc/components/button.dart';
import 'package:coc/components/case_base_details.dart';
import 'package:coc/components/lists/case_user.dart';
import 'package:coc/components/lists/media_evidence.dart';
import 'package:coc/components/lists/tagged_evidence.dart';
import 'package:coc/pages/forms/register_evidence.dart';
import 'package:coc/pages/pictures.dart';
import 'package:coc/pages/scanner.dart';
import 'package:coc/pages/scan_any_tag.dart';
import 'package:coc/service/data.dart';

class CaseDetailView extends WatchingWidget {
  const CaseDetailView({super.key});

  static Future<bool> hasInternetConnection() async {
    return await InternetConnectionChecker().hasConnection;
  }

  @override
  build(BuildContext context) {
    final caseItem = watchIt<DataService>().currentCase;

    if (caseItem == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
              const SizedBox(height: 16),
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
              const SizedBox(height: 8),
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
              const SizedBox(height: 8),
              Button(
                title: 'Transfer evidence',
                icon: Icons.qr_code_scanner,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScanAnyTagPage(onScan: navigateToEvidenceTransfer()),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              CaseDetails(caseItem: caseItem),
              const SizedBox(height: 10),
              // Handler/caseUser container
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[800],
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
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
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
                  color: Colors.grey[800],
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
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
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
                  color: Colors.grey[800],
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
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PictureTakingPage(caseItem: caseItem),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    LimMediaEvidenceList(
                      mediaEvidence: caseItem.mediaEvidence,
                      itemCount: 4,
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
