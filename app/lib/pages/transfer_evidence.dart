// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:coc/main.dart';
import 'package:coc/pages/login.dart';
import 'package:coc/service/authentication.dart';
import 'package:coc/service/enviroment.dart';
import 'package:coc/service/location.dart';
import 'package:watch_it/watch_it.dart';

Function(BuildContext, String) navigateToEvidenceTransfer() {
  onscan(BuildContext context, String evidenceId) {
    Navigator.push(
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

  Future<Map<String, dynamic>> submitTransferData() async {
    final url = Uri.parse(
        '${EnvironmentConfig.apiUrl}/evidence/tag/${widget.evidenceID}/transfer');
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': di<Authentication>().bearerToken,
    };
    final body = {
      'coordinates': _location,
    };
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      return {
        'response': response,
        'request': {'url': url.toString(), 'headers': headers, 'body': body}
      };
    } catch (e) {
      return {
        'response': http.Response('Error: $e', 500),
        'request': {'url': url.toString(), 'headers': headers, 'body': body}
      };
    }
  }

  void handleResponse(result) {
    http.Response response = result['response'];
    if (response.statusCode == 401) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Unauthorized'),
            content: Text('Check your credentials, please log in again.'),
            actions: <Widget>[
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              ),
            ],
          );
        },
      );
    } else if (response.statusCode == 201) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Successful"),
            content: Text("Transfer submitted successfully"),
            actions: <Widget>[
              ElevatedButton(
                child: Text('Home'),
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
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Failed'),
            content: Text('Failed for unknown reason'),
            actions: <Widget>[
              ElevatedButton(
                child: Text('OK'),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer Evidence'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Scanned Evidence ID: ${widget.evidenceID}'),
            SizedBox(height: 20),
            _isFetchingLocation
                ? CircularProgressIndicator()
                : Text('Current Location: $_location'),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Submit"),
              onPressed: () async {
                Map<String, dynamic> result = await submitTransferData();
                handleResponse(result);
              },
            ),
          ],
        ),
      ),
    );
  }
}
