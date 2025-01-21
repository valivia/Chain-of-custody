// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:nfc_manager/nfc_manager.dart';

// Project imports:
import 'package:coc/pages/transfer_evidence.dart';

class NfcScanPage extends StatefulWidget {
  const NfcScanPage({super.key});

  @override
  NfcScanPageState createState() => NfcScanPageState();
}

class NfcScanPageState extends State<NfcScanPage> {
  ValueNotifier<Map<String, dynamic>> result = ValueNotifier({});

  @override
  void initState() {
    super.initState();
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      try {
        Map<String, dynamic> tagData = {};
        String evidenceId = '';

        final ndef = tag.data['ndef'];
        if (ndef != null) {
          final ndefMessage = ndef['cachedMessage'];
          if (ndefMessage != null) {
            for (var record in ndefMessage['records']) {
              if (record['typeNameFormat'] == 'nfcWellknown' &&
                  record['type'].length == 1 &&
                  record['type'].first == 0x54) {
                final languageCodeLength = record['payload'].first;
                final text = String.fromCharCodes(
                    record['payload'].sublist(1 + languageCodeLength));
                evidenceId = text;
                tagData['text'] = text;
              }
            }
          } else {
            tagData['message'] = 'No NDEF message found on the tag.';
          }
        } else {
          tagData['message'] = 'No NDEF data found on the tag.';
        }

        result.value = tagData;
        if (evidenceId.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransferEvidencePage(
                evidenceID: evidenceId,
              ),
            ),
          );
        } else {
          result.value = {'error': 'No evidence ID found on the tag.'};
        }
      } catch (e) {
        result.value = {'error': 'Error reading NFC tag: $e'};
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
          child: ValueListenableBuilder<Map<String, dynamic>>(
            valueListenable: result,
            builder: (context, value, _) {
              if (value.isEmpty) {
                return const Text('Scan an NFC tag');
              } else {
                return Text('Error: ${value['error']}');
              }
            },
          ),
        ),
      ),
    );
  }
}
