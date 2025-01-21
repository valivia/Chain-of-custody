import 'package:flutter/material.dart';
import 'dart:developer';


Function(BuildContext, String) navigateToEvidenceTransfer() {
  onscan(BuildContext context, String evidenceId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransferEvidencePage(
          evidenceID: evidenceId,
        ),
      ),
    );
  }
  return onscan;
}

class TransferEvidencePage extends StatefulWidget {
  final String evidenceID;

  TransferEvidencePage({required this.evidenceID});

  @override
  TransferEvidencePageState createState() => TransferEvidencePageState();
}

class TransferEvidencePageState extends State<TransferEvidencePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer Evidence'),
      ),
      body: Center(
        child: Text('Scanned Evidence ID: ${widget.evidenceID}'),
      ),
    );
  }
}
