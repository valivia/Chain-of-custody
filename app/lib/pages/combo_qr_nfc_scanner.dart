// Flutter imports:
import 'dart:developer';

import 'package:flutter/material.dart';

// Package imports:
import 'package:nfc_manager/nfc_manager.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

// Project imports:
import 'package:coc/pages/transfer_evidence.dart';

class ComboScannerPage extends StatefulWidget {
  final Function(BuildContext, String) onScan;

  const ComboScannerPage({super.key, required this.onScan});

  @override
  ComboScannerPageState createState() => ComboScannerPageState();
}

class ComboScannerPageState extends State<ComboScannerPage> {
  final MobileScannerController scannerController = MobileScannerController();
  ValueNotifier<Map<String, dynamic>> result = ValueNotifier({});
  bool isNfcAvailable = false;
  bool hasNavigated = false; // To ensure navigation happens only once

  @override
  void initState() {
    super.initState();
    scannerController.start();
    checkNfcAvailability();
  }

  void checkNfcAvailability() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    setState(() {
      isNfcAvailable = isAvailable;
    });
    log('NFC Availability: $isNfcAvailable'); // Debugging log
    if (isNfcAvailable) {
      startNfcSession();
    }
  }

  void startNfcSession() {
    log('Starting NFC session'); // Debugging log
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      try {
        Map<String, dynamic> tagData = {};
        String evidenceId = '';

        final ndef = tag.data['ndef'];
        if (ndef != null) {
          final ndefMessage = ndef['cachedMessage'];
          if (ndefMessage != null) {
            for (var record in ndefMessage['records']) {
              if (
                  (record['typeNameFormat'] == 'nfcWellknown' || record['typeNameFormat'] == 1) &&
                  record['type'].length == 1 &&
                  record['type'].first == 0x54) {
                final languageCodeLength = record['payload'][0];
                final text = String.fromCharCodes(
                    record['payload'].sublist(1 + languageCodeLength));
                evidenceId = text;
                tagData['text'] = text;
                log('NFC Tag Data: $tagData'); // Debugging log
              }
            }
          } else {
            tagData['message'] = 'No NDEF message found on the tag.';
            log('No NDEF message found on the tag.'); // Debugging log
          }
        } else {
          tagData['message'] = 'No NDEF data found on the tag.';
          log('No NDEF data found on the tag.'); // Debugging log
        }

        result.value = tagData;
        if (evidenceId.isNotEmpty) {
          navigateToTransferEvidence(context, evidenceId);
        } else {
          result.value = {'error': 'No evidence ID found on the tag.'};
          log('No evidence ID found on the tag.'); // Debugging log
        }
      } catch (e) {
        result.value = {'error': 'Error reading NFC tag: $e'};
        log('Error reading NFC tag: $e'); // Debugging log
      } finally {
        NfcManager.instance.stopSession();
      }
    });
  }

  void navigateToTransferEvidence(BuildContext context, String evidenceId) {
    if (!hasNavigated) {
      hasNavigated = true;
      widget.onScan(context, evidenceId);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TransferEvidencePage(
            evidenceID: evidenceId,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    scannerController.dispose();
    if (isNfcAvailable) {
      NfcManager.instance.stopSession();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Combo Scanner'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: MobileScanner(
              controller: scannerController,
              onDetect: (barcodeCapture) async {
                final barcode = barcodeCapture.barcodes.first;
                if (barcode.rawValue != null) {
                  final String code = barcode.rawValue!;
                  scannerController.stop();
                  result.value = {'text': code};
                  log('QR Code Data: $code'); // Debugging log
                  navigateToTransferEvidence(context, code);
                  if (mounted) {
                    scannerController.start();
                  }
                }
              },
            ),
          ),
          if (isNfcAvailable)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('NFC is available. Tap an NFC tag to scan.'),
            ),
          if (!isNfcAvailable)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('NFC is not available on this device.'),
            ),
          ValueListenableBuilder<Map<String, dynamic>>(
            valueListenable: result,
            builder: (context, value, _) {
              if (value.isEmpty) {
                return const Text('Scan an NFC tag or QR code');
              } else if (value.containsKey('error')) {
                return Text('Error: ${value['error']}');
              } else {
                return Text('NFC Tag Data: ${value['text']}');
              }
            },
          ),
        ],
      ),
    );
  }
}