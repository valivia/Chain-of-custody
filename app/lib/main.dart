import 'package:coc/scanner.dart';
import 'package:flutter/material.dart';
import 'pages/pictures.dart'; // Import the new pictures.dart file

void main() {
  runApp(const MaterialApp(
    title: 'Navigation Basics',
    home: FirstRoute(),
    debugShowCheckedModeBanner: false,
  ));
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Route'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Scan QR Code'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QRScannerPage()),
                );
              },
            ),
            const SizedBox(height: 20), // Add some space between the buttons
            ElevatedButton(
              child: const Text('Take Picture'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PictureTakingPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}