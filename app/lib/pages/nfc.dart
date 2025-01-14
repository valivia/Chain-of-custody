import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

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
      Map<String, dynamic> tagData = tag.data;
      result.value = tagData;
      NfcManager.instance.stopSession();
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
                return  const Text('Scan an NFC tag');
              } else {
                return ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: value.entries.map((entry) {
                    return ListTile(
                      title: Text(entry.key),
                      subtitle: Text(entry.value.toString()),
                    );
                  }).toList(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}