import 'package:flutter/material.dart';
import 'package:coc/service/edit_formats.dart';

Widget buildCaseDetails(caseItem) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Case details',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 5),
      Text("Status: ${caseItem.caseStatusString.toUpperCase()}"),
      const SizedBox(height: 5),
      Text("ID: ${caseItem.id}"),
      const SizedBox(height: 5),
      Text(
          "Created at: ${EditFormats().formatTimestamp(caseItem.createdAt).toString()}"),
      const SizedBox(height: 5),
      Text(
          "Updated at: ${EditFormats().formatTimestamp(caseItem.updatedAt).toString()}"),
      const SizedBox(height: 8),
      const Text(
        'Description',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 5),
      Text("${caseItem.description}"),
    ],
  );
}
