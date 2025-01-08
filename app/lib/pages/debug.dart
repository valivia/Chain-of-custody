import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:coc/pages/scanner.dart';
import 'package:coc/pages/pictures.dart';
import 'package:coc/pages/nfc.dart';
import 'package:coc/pages/login.dart';
import 'package:coc/components/evidence_list.dart';
import 'package:coc/service/case.dart';
import 'package:coc/pages/case_detail.dart';

class DebugPage extends StatelessWidget {
  const DebugPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(45, 45, 45, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(23, 23, 23, 1),
        leading: const Icon(Icons.home, color: Colors.white),
        title: const Text('Debug'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 20), // Add spacing between buttons
              ElevatedButton(
                child: const Text('Scan QR Code'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QRScannerPage()),
                  );
                },
              ),
              const SizedBox(height: 20), // Add spacing between buttons
              ElevatedButton(
                child: const Text('Take Picture'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PictureTakingPage()),
                  );
                },
              ),
              const SizedBox(height: 20), // Add spacing between buttons
              ElevatedButton(
                child: const Text('Scan NFC Tag'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NfcScanPage()),
                  );
                },
              ),
              const SizedBox(height: 20), // Add spacing between buttons
              ElevatedButton(
                child: const Text('Login page'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Case List',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<List<Case>>(
                      future: Case.fetchCases(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error occurred: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No cases found attached to you'));
                        } else {
                          final caseList = snapshot.data!;
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: caseList.length,
                            itemBuilder: (context, index) {
                              final caseItem = caseList[index];
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(10),
                                ),
                                onPressed: () {
                                  // TODO: Handle item click
                                  log('Clicked on ${caseItem.caseID}');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CaseDetailView(caseItem: caseItem),
                                    ),
                                  );
                                },
                                child: Text("ID: ${caseItem.caseID}"),
                              );
                            },
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
