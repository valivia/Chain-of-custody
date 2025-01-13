// import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:coc/pages/scanner.dart';
import 'package:coc/pages/pictures.dart';
import 'package:coc/pages/nfc.dart';
import 'package:coc/pages/login.dart';
import 'package:coc/components/case_list.dart';
import 'package:coc/components/local_store.dart';
// import 'package:coc/components/evidence_list.dart';
// import 'dart:math';

class DebugPage extends StatelessWidget {
  const DebugPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme bTextTheme = Theme.of(context).textTheme;
    return Scaffold(
      //backgroundColor: const Color.fromRGBO(45, 45, 45, 1),
      appBar: AppBar(
        //backgroundColor: const Color.fromRGBO(23, 23, 23, 1),
        leading: const Icon(Icons.home, color: Colors.white),
        centerTitle: true,
        title: Text('Debug',style: bTextTheme.headlineMedium,),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 20), // Add spacing between buttons
              ElevatedButton(
                child: Text('Scan QR Code', style: bTextTheme.bodyMedium,),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QRScannerPage()),
                  );
                },
              ),
              const SizedBox(height: 20), // Add spacing between buttons
              ElevatedButton(
                child: Text('Evidence List', style: bTextTheme.bodyMedium,),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => EvidenceListView()),
                  // );
                },
              ),
              const SizedBox(height: 20), // Add spacing between buttons
              ElevatedButton(
                child: Text('Take Picture', style: bTextTheme.bodyMedium,),
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
                child: Text('Scan NFC Tag', style: bTextTheme.bodyMedium,),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NfcScanPage()),
                  );
                },
              ),
              const SizedBox(height: 20), // Add spacing between buttons
              ElevatedButton(
                child: Text('Login page', style: bTextTheme.bodyMedium,),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              CaseList(),
              const SizedBox(height: 20), // Add spacing between buttons
              ElevatedButton(
                onPressed: () async {
                  var allData = await LocalStore.getAllData();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('All Data from Hive', style: bTextTheme.bodyMedium,),
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
                            child: Text('OK', style: bTextTheme.bodyMedium,),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Get All Data from Hive', style: bTextTheme.bodyMedium,),
              ),
              const SizedBox(height: 20), // Add spacing between buttons
              ElevatedButton(
                onPressed: () async {
                  await LocalStore.clearApiCache();
                  print('Hive cache cleared');
                },
                child: Text('Clear Cache', style: bTextTheme.bodyMedium,),
              ),
              const SizedBox(height: 20), // Add spacing between buttons
              ElevatedButton(
                onPressed: () async {
                  List<Map<String, String>> statusList = await LocalStore.sendAllSavedRequests();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Send Status', style: bTextTheme.headlineMedium,),
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
                            child: Text('OK', style: bTextTheme.bodyMedium,),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Send All Saved Data', style: bTextTheme.bodyMedium,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
