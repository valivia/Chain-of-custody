import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'form.dart';

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  MobileScannerController _scannerController = MobileScannerController();

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
      ),
      body: MobileScanner(
        controller: _scannerController,
        onDetect: (barcodeCapture) {
          final barcode = barcodeCapture.barcodes.first;
          if (barcode.rawValue != null) {
            final String code = barcode.rawValue!;
            _scannerController.stop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FormPage(scannedData: {'qrData': code}),
              ),
            ).then((_) {
              // Resume the camera when returning to the scanner page
              _scannerController.start();
            });
          }
        },
      ),
    );
  }
}