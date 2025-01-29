// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:watch_it/watch_it.dart';

// Project imports:
import 'package:coc/components/lists/case.dart';
import 'package:coc/components/local_store.dart';
import 'package:coc/pages/image_gallery.dart';
import 'package:coc/pages/login.dart';
import 'package:coc/pages/nfc.dart';
import 'package:coc/pages/scan_any_tag.dart';
import 'package:coc/pages/scanner.dart';
import 'package:coc/pages/transfer_evidence.dart';
import 'package:coc/service/data.dart';

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
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 20), // Add spacing between buttons
                ElevatedButton(
                  child: const Text('Sync with API'),
                  onPressed: () {
                    di<DataService>().syncWithApi();
                  },
                ),
                const SizedBox(height: 20), // Add spacing between buttons
                ElevatedButton(
                  child: const Text('View Images'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ImageGalleryPage()),
                    );
                  },
                ),
                const SizedBox(height: 20), // Add spacing between buttons
                ElevatedButton(
                  child: const Text('Scan NFC Tag'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NfcScanPage(onScan: navigateToEvidenceTransfer())),
                    );
                  },
                ),
                const SizedBox(height: 20), // Add spacing between buttons
                ElevatedButton(
                  child: const Text('Scan QR Code'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  QRScannerPage(onScan: navigateToEvidenceTransfer()),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20), // Add spacing between buttons
                ElevatedButton(
                  child: const Text('Scan QR/NFC Tag'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScanAnyTagPage(
                          onScan: navigateToEvidenceTransfer(), 
                          title: "Transfer Evidence",
                          ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20), // Add spacing between buttons
                ElevatedButton(
                  child: const Text('Login page'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                ),
                const SizedBox(height: 20), // Add spacing between buttons
                const LimCaseList(itemCount: 2),
                const SizedBox(height: 20), // Add spacing between buttons
                ElevatedButton(
                  onPressed: () async {
                    var allData = await LocalStore.getAllData();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('All Data from Hive'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: allData.entries.map((entry) {
                                return Text('${entry.key}: ${entry.value}');
                              }).toList(),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Get All Data from Hive'),
                ),
                const SizedBox(height: 20), // Add spacing between buttons
                ElevatedButton(
                  onPressed: () async {
                    await LocalStore.clearApiCache();
                    print('Hive cache cleared');
                  },
                  child: const Text('Clear Cache'),
                ),
                const SizedBox(height: 20), // Add spacing between buttons
                ElevatedButton(
                  onPressed: () async {
                    List<Map<String, String>> statusList = await LocalStore.sendAllSavedRequests();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Send Status'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: statusList.map((status) {
                                return Row(
                                  children: [
                                    Expanded(
                                      child: Text(status['status'] != 'Success'
                                          ? '${status['id']}     ${status['type']}     ${status['status']}'
                                          : '${status['id']}     ${status['type']}'),
                                    ),
                                    Icon(
                                      status['status'] == 'Success' ? Icons.check_circle : Icons.close,
                                      color: status['status'] == 'Success' ? Colors.green : Colors.red,
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Send All Saved Data'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
