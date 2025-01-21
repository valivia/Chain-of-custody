import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NfcScanPage extends StatefulWidget {
  const NfcScanPage({super.key});

  @override
  NfcScanPageState createState() => NfcScanPageState();
}

class NfcScanPageState extends State<NfcScanPage> {
  ValueNotifier<String> result = ValueNotifier('Scan an NFC tag');

  @override
  void initState() {
    super.initState();
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      try {
        final ndef = Ndef.from(tag);
        if (ndef == null) {
          result.value = 'This NFC tag does not support NDEF.';
          return;
        }

        if (ndef.cachedMessage == null) {
          result.value = 'No NDEF data found on the tag.';
          return;
        }

        final ndefMessage = ndef.cachedMessage!;
        String parsedResult = '';

        for (var record in ndefMessage.records) {
          if (record.typeNameFormat == NdefTypeNameFormat.nfcWellknown &&
              record.type.length == 1 &&
              record.type.first == 0x54) {
            final languageCodeLength = record.payload.first;
            final text = String.fromCharCodes(
                record.payload.sublist(1 + languageCodeLength));
            parsedResult += '$text\n';
          }
        }

        result.value = parsedResult.isNotEmpty
            ? parsedResult.trim()
            : 'No text records found on the tag.';
      } catch (e) {
        result.value = 'Error reading NFC tag: $e';
      } finally {
        NfcManager.instance.stopSession();
      }
    });
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan NFC Tag')),
      body: SafeArea(
        child: Center(
          child: ValueListenableBuilder<String>(
            valueListenable: result,
            builder: (context, value, _) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
