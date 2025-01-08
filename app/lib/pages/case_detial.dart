import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:coc/service/evidence.dart';
import 'package:coc/service/edit_formats.dart';
import 'package:coc/service/case.dart';

class CaseDetailView extends StatelessWidget {
  const CaseDetailView({super.key, required this.caseItem});
  final Case caseItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CASE ID: ${caseItem.caseID}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Case Title: ${caseItem.caseTitle}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ] ,
        ),
      ),
    );
  }
}
