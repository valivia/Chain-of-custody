// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:geolocator/geolocator.dart';
import 'package:watch_it/watch_it.dart';

// Project imports:
import 'package:coc/controllers/tagged_evidence.dart';
import 'package:coc/main.dart';
import 'package:coc/service/api_service.dart';
import 'package:coc/service/location.dart';

Function(BuildContext, String) navigateToEvidenceTransfer() {
  onscan(BuildContext context, String evidenceId) {
    Navigator.pushReplacement(
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

  const TransferEvidencePage({super.key, required this.evidenceID});

  @override
  TransferEvidencePageState createState() => TransferEvidencePageState();
}

class TransferEvidencePageState extends State<TransferEvidencePage> {
  bool _isFetchingLocation = false;
  String _location = "Unknown";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isFetchingLocation = true;
    });

    // When we reach here, permissions are granted and we can continue
    Position position = await di<LocationService>()
        .getCurrentLocation(desiredAccuracy: LocationAccuracy.lowest);
    setState(() {
      _location = '${position.latitude}, ${position.longitude}';
      _isFetchingLocation = false;
    });
  }

  void handleResponse() async {
    try {
      await TaggedEvidence.transfer(
        id: widget.evidenceID,
        coordinates: _location,
      );

      showDialog(
        context: navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Successful"),
            content: const Text("Transfer submitted successfully"),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Home'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
              ),
            ],
          );
        },
      );
    } on ApiException catch (error) {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (BuildContext context) {
          // Not found
          if (error.code == 404) {
            return AlertDialog(
              title: const Text('Not found'),
              content: const Text('This evidence has not been registered yet.'),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );

            // Unknown error
          } else {
            return AlertDialog(
              title: const Text('Failed'),
              content: Text(error.message),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                ),
              ],
            );
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer Evidence'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Scanned Evidence ID: ${widget.evidenceID}'),
            const SizedBox(height: 20),
            _isFetchingLocation
                ? const CircularProgressIndicator()
                : Text('Current Location: $_location'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleResponse,
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
