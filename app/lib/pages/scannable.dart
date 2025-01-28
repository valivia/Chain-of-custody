// Flutter imports:
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ScannablePage extends StatelessWidget {
  final String data;
  final String? description;
  final Function(BuildContext)? onDone;

  const ScannablePage({
    super.key,
    required this.data,
    this.description,
    this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
              Text(description!),
            ],
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Go back"),
                ),
                ElevatedButton(
                  onPressed: onDone != null
                      ? () => onDone!(context)
                      : () {
                          Navigator.pop(context);
                        },
                  child: const Text("Done"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
