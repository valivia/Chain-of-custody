import 'package:flutter/material.dart';
import 'package:coc/pages/scanner.dart';
import 'package:coc/pages/pictures.dart';
import 'package:coc/pages/nfc.dart';

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
            ],
          ),
        ),
      ),
    );
  }
}