// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:coc/components/failed_animation.dart';
import 'package:coc/components/success_animation.dart';
import 'package:coc/controllers/case.dart';
import 'package:coc/pages/case_detail.dart';
import 'package:coc/pages/forms/register_evidence.dart';
import 'package:coc/pages/scanner.dart';

void showSuccessDialog(BuildContext context, String message, Case caseItem) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SuccessAnimation(
                size: 200,
                onComplete: () {},
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
                      // di<DataService>().currentCase = caseItem;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CaseDetailView(),
                        ),
                        (Route<dynamic> route) =>
                            route.isFirst, // Keep the main page in the stack
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
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRScannerPage(
                              onScan: navigateToEvidenceCreate(caseItem)),
                        ),
                        (Route<dynamic> route) =>
                            route.isFirst, // Keep the main page in the stack
                      );
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
        ),
      );
    },
  );
}

void showFailureDialog(BuildContext context, String message, Case caseItem) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return PopScope(
        canPop: true,
        child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FailedAnimation(
                size: 200,
                onComplete: () {},
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
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CaseDetailView(),
                        ),
                        (Route<dynamic> route) =>
                            route.isFirst, // Keep the main page in the stack
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
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRScannerPage(
                              onScan: navigateToEvidenceCreate(caseItem)),
                        ),
                        (Route<dynamic> route) =>
                            route.isFirst, // Keep the main page in the stack
                      );
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
        ),
      );
    },
  );
}
