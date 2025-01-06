import 'package:flutter/material.dart';
import 'package:coc/pages/scanner.dart';
import 'package:coc/pages/pictures.dart';
import 'package:coc/pages/nfc.dart';
import 'package:coc/pages/login.dart';
import 'package:coc/components/local_store.dart';

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
              const SizedBox(height: 20), // Add spacing between buttons
              ElevatedButton(
                onPressed: () async {
                  var allData = await LocalStore.getAllData();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('All Data from Hive'),
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
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Get All Data from Hive'),
              ),
              const SizedBox(height: 20), // Add spacing between buttons
              ElevatedButton(
                onPressed: () async {
                  await LocalStore.clearApiCache();
                  print('Hive cache cleared');
                },
                child: Text('Clear Cache'),
              ),
              const SizedBox(height: 20), // Add spacing between buttons
              ElevatedButton(
                onPressed: () async {
                  List<Map<String, String>> statusList = await LocalStore.sendAllSavedRequests();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Send Status'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: statusList.map((status) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: Text('${status['id']}    ${status['status']}'),
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
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Send All Saved Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}