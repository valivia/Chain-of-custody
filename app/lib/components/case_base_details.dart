import 'package:flutter/material.dart';
import 'package:coc/service/edit_formats.dart';

Widget buildCaseDetails(caseItem) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Case Title: ${caseItem.title}',
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      Text(
        'Case ID: ${caseItem.id}',
        style: const TextStyle(fontSize: 18),
      ),
      const SizedBox(height: 8),
      // case details
      const SizedBox(height: 8),
      const Text(
        'Case details',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 5),
      Text("Case status: ${caseItem.caseStatusString.toUpperCase()}"),
      const SizedBox(height: 5),
      Text("Case description: \n${caseItem.description}"),
      const SizedBox(height: 5),
      Text("Created at: ${EditFormats().formatTimestamp(caseItem.createdAt).toString()}"),
      const SizedBox(height: 5),
      Text("Updated at: ${EditFormats().formatTimestamp(caseItem.updatedAt).toString()}"),
      const SizedBox(height: 8),
    ],
  );
}