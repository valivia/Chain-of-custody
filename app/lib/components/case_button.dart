import 'package:flutter/material.dart';
import 'package:coc/pages/case_detail.dart';
import 'package:coc/controllers/case.dart';

Widget caseButton(BuildContext context, Case caseItem) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CaseDetailView(caseItem: caseItem),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                caseItem.title,
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                caseItem.id,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
