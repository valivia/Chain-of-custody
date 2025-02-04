// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerPage extends StatefulWidget {
  final Function(BuildContext, String) onScan;
  final String title;

  const QRScannerPage({
    super.key,
    required this.onScan,
    this.title = "Scan QR Code",
  });

  @override
  QRScannerPageState createState() => QRScannerPageState();
}

class QRScannerPageState extends State<QRScannerPage> {
  final MobileScannerController scannerController = MobileScannerController();

  @override
  void initState() {
    super.initState();
    scannerController.start();
  }

  @override
  void dispose() {
    scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme aTextTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: aTextTheme.headlineMedium,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: MobileScanner(
        controller: scannerController,
        onDetect: (barcodeCapture) async {
          final barcode = barcodeCapture.barcodes.first;
          if (barcode.rawValue != null) {
            final String code = barcode.rawValue!;
            scannerController.stop();
            await widget.onScan(context, code);
            if (mounted) {
              scannerController.start();
            }
          }
        },
      ),
    );
  }
}
