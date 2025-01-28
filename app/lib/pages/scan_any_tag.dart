// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:coc/pages/nfc.dart';
import 'package:coc/pages/scanner.dart';
import 'package:coc/pages/transfer_evidence.dart';

class ScanAnyTagPage extends StatelessWidget {
  const ScanAnyTagPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer Evidence'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Scan NFC tag to transfer evidence',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Tap the tag to the top of the phone',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Or tap the button below to use QR scanner to scan the tag instead.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 400, // Set a fixed height for the NFC scan area
              child: NfcScanPage(onScan: navigateToEvidenceTransfer()),
            ),
            const SizedBox(height: 20), 
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRScannerPage(
                      onScan: navigateToEvidenceTransfer(),
                    ),
                  ),
                );
              },
              child: const Text('Scan QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}