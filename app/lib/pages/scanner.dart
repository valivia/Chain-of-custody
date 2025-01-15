import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerPage extends StatefulWidget {
  final Function(BuildContext, String) onScan;
  const QRScannerPage({super.key, required this.onScan});

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
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