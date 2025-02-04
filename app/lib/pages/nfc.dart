// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:nfc_manager/nfc_manager.dart';

// Project imports:
import 'package:coc/components/dot_wait_indicator.dart';

class NfcScanPage extends StatefulWidget {
  final Function(BuildContext, String) onScan;
  const NfcScanPage({super.key, required this.onScan});

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
              if ((record['typeNameFormat'] == 'nfcWellknown' ||
                      record['typeNameFormat'] == 1) &&
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
          widget.onScan(context, evidenceId);
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
    TextTheme aTextTheme = Theme.of(context).textTheme;
    return Scaffold(
      // appBar: AppBar(title: const Text('Scan NFC Tag')),
      body: SafeArea(
        child: Center(
          child: ValueListenableBuilder<Map<String, dynamic>>(
            valueListenable: result,
            builder: (context, value, _) {
              if (value.isEmpty) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Waiting for scan ', style: aTextTheme.displaySmall),
                    const ThreeDotsWaitIndicator(),
                  ],
                );
              } else {
                return Text('Error: ${value['error']}', style: aTextTheme.displaySmall);
              }
            },
          ),
        ),
      ),
    );
  }
}
