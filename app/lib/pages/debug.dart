// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:watch_it/watch_it.dart';

// Project imports:
import 'package:coc/components/lists/case.dart';
import 'package:coc/components/local_store.dart';
import 'package:coc/pages/image_gallery.dart';
import 'package:coc/pages/login.dart';
import 'package:coc/service/data.dart';

class DebugPage extends StatelessWidget {
  const DebugPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme bTextTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.home, color: Colors.white),
        centerTitle: true,
        title: Text(
          'Debug',
          style: bTextTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 20), // Add spacing between buttons
                ElevatedButton(
                  child: Text(
                    'Sync with API',
                    style: bTextTheme.labelLarge,
                  ),
                  onPressed: () {
                    di<DataService>().syncWithApi();
                  },
                ),
                const SizedBox(height: 20), // Add spacing between buttons
                ElevatedButton(
                  child: Text(
                    'View Images',
                    style: bTextTheme.labelLarge,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageGalleryPage()),
                    );
                  },
                ),
                const SizedBox(height: 20), // Add spacing between buttons
                ElevatedButton(
                  child: Text(
                    'Login page',
                    style: bTextTheme.labelLarge,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
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
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'OK',
                                style: bTextTheme.labelLarge,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    'Get All Data from Hive',
                    style: bTextTheme.labelLarge,
                  ),
                ),
                const SizedBox(height: 20), // Add spacing between buttons
                ElevatedButton(
                  onPressed: () async {
                    await LocalStore.clearApiCache();
                    print('Hive cache cleared');
                  },
                  child: Text(
                    'Clear Cache',
                    style: bTextTheme.labelLarge,
                  ),
                ),
                const SizedBox(height: 20), // Add spacing between buttons
                ElevatedButton(
                  onPressed: () async {
                    List<Map<String, String>> statusList =
                        await LocalStore.sendAllSavedRequests();
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
                                      child: Text(
                                        status['status'] != 'Success'
                                            ? '${status['id']}     ${status['type']}     ${status['status']}'
                                            : '${status['id']}     ${status['type']}',
                                        style: bTextTheme.bodyMedium,
                                      ),
                                    ),
                                    Icon(
                                      status['status'] == 'Success'
                                          ? Icons.check_circle
                                          : Icons.close,
                                      color: status['status'] == 'Success'
                                          ? Colors.green
                                          : Colors.red,
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
                              child: Text(
                                'OK',
                                style: bTextTheme.labelLarge,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    'Send All Saved Data',
                    style: bTextTheme.labelLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
