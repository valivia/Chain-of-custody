import 'package:coc/controllers/case.dart';
import 'package:coc/pages/case_detail.dart';
import 'package:coc/pages/register_evidence.dart';
import 'package:coc/pages/scanner.dart';
import 'package:flutter/material.dart';
import 'package:coc/components/success_animation.dart'; 
import 'package:coc/components/failed_animation.dart'; 

void showSuccessDialog(BuildContext context, String message, Case caseItem) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SuccessAnimation(
              size: 200,
              onComplete: () {
              },
            ),
            const SizedBox(height: 20),
            Text(message),
          ],
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CaseDetailView(caseItem: caseItem),
                      ),
                    );
                  },
                  child: const Text(
                    'Go to Case',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => QRScannerPage(onScan: navigateToEvidenceCreate(caseItem))),);
                  },
                  child: const Text(
                    'Scan More',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

void showFailureDialog(BuildContext context, String message, Case caseItem) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FailedAnimation(
              size: 200,
              onComplete: () {
                // Optional: Do something when the animation completes
              },
            ),
            const SizedBox(height: 20),
            Text(message),
          ],
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CaseDetailView(caseItem: caseItem),
                      ),
                    );
                  },
                  child: const Text(
                    'Go to Main',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Scan More',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}