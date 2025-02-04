// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:coc/pages/nfc.dart';
import 'package:coc/pages/scanner.dart';

class ScanAnyTagPage extends StatelessWidget {
  final Function(BuildContext, String) onScan;
  final String title;

  const ScanAnyTagPage({
    super.key,
    required this.onScan,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme aTextTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          title,
          style: aTextTheme.headlineMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Scan NFC tag to read the tag\'s ID',
              style: aTextTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Hold the tag close to the device\'s NFC scanner',
              style: aTextTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Or tap the button below to use QR scanner to scan the tag\'s ID instead.',
              style: aTextTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 400, // Set a fixed height for the NFC scan area
              child: NfcScanPage(onScan: onScan),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRScannerPage(
                      onScan: onScan,
                      title: title,
                    ),
                  ),
                );
              },
              child: Text(
                'Scan QR Code',
                style: aTextTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
