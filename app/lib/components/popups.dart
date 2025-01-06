import 'package:flutter/material.dart';
import 'package:coc/components/success_animation.dart'; // Import the success animation widget
import 'package:coc/components/failed_animation.dart'; // Import the failed animation widget
import 'package:coc/main.dart'; // Import the main screen widget
import 'package:coc/pages/scanner.dart'; // Import the scan screen widget

void showSuccessDialog(BuildContext context, String message) {
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
                // Optional: Do something when the animation completes
              },
            ),
            SizedBox(height: 20),
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
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => App()), // Replace with your main screen widget
                    );
                  },
                  child: Text(
                    'Go to Main',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QRScannerPage()), // Replace with your scan screen widget
                    );
                  },
                  child: Text(
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

void showFailureDialog(BuildContext context, String message) {
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
            SizedBox(height: 20),
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
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => App()), // Replace with your main screen widget
                    );
                  },
                  child: Text(
                    'Go to Main',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QRScannerPage()), // Replace with your scan screen widget
                    );
                  },
                  child: Text(
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