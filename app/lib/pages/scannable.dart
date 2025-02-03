// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:qr_flutter/qr_flutter.dart';

class ScannablePage extends StatelessWidget {
  final String title;
  final String? description;
  final String data;
  final Function(BuildContext)? onDone;

  const ScannablePage({
    super.key,
    this.onDone,
    required this.data,
    this.title = "Scannable",
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // QR code
            QrImageView(
              data: data,
              version: QrVersions.auto,
              errorCorrectionLevel: QrErrorCorrectLevel.H,
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(20),
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Colors.black,
              ),
            ),

            // Go back button
            if (description != null && description!.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(description!, textAlign: TextAlign.center),
            ],
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Go back"),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onDone != null
                        ? () => onDone!(context)
                        : () {
                            Navigator.pop(context);
                          },
                    child: const Text("Done"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
