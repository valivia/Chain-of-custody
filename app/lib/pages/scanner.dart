// Flutter imports:
import 'dart:developer';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
          log(" --- barcode detected --- ");
          final barcode = barcodeCapture.barcodes.first;
          log(" --- Scanned code value : ${barcode.toString()} --- ");
          if (barcode.rawValue != null) {
            log(" --- Barcode Rawvalue not null");
            final String code = barcode.rawValue!;
            log(" --- rawvalue code value : ${code} --- ");
            scannerController.stop();
            log( " --- Scanner controller stopped --- ");
            await widget.onScan(context, code);
            log(" --- awaiting redirect with onScan function --- ");
            if (mounted) {
              log(" --- camera mounted --- ");
              scannerController.start();
              log(" --- scanner controller started --- ");

            }
          }
        },
      ),
    );
  }
}
