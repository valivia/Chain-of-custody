import 'package:coc/main.dart';
import 'package:coc/service/authentication.dart';
import 'package:coc/service/location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:coc/pages/scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:coc/components/succes_animation.dart';
import 'package:coc/components/failed_animation.dart';

class RegisterEvidencePage extends StatefulWidget {
  final Map<String, dynamic> scannedData;

  const RegisterEvidencePage({super.key, required this.scannedData});

  @override
  RegisterEvidencePageState createState() => RegisterEvidencePageState();
}

class RegisterEvidencePageState extends State<RegisterEvidencePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _idController;
  late TextEditingController _containerTypeController;
  late TextEditingController _itemTypeController;
  late TextEditingController _descriptionController;
  late TextEditingController _originCoordinatesController;
  late TextEditingController _originLocationDescriptionController;
  String? _selectedContainerType;
  final _containerTypes = ['Box', 'Crate', 'Pallet', 'Other', 'dsjn'];
  bool _isFetchingLocation = false;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.scannedData['qrData']);
    _containerTypeController = TextEditingController();
    _itemTypeController = TextEditingController();
    _descriptionController = TextEditingController();
    _originCoordinatesController = TextEditingController();
    _originLocationDescriptionController = TextEditingController();

    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isFetchingLocation = true;
    });

    // When we reach here, permissions are granted and we can continue
    Position position =
        await globalState<LocationService>().getCurrentLocation();
    setState(() {
      _originCoordinatesController.text =
          '${position.latitude}, ${position.longitude}';
      _isFetchingLocation = false;
    });
  }

  Future<http.Response> submitEvidenceData() async {
    final url = Uri.parse('https://coc.hootsifer.com/evidence/tag');
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': await Authentication.getBearerToken(),
    };
    final body = jsonEncode({
      'id': _idController.text,
      'containerType': 1,
      'itemType': _itemTypeController.text,
      'description': _descriptionController.text,
      'originCoordinates': _originCoordinatesController.text,
      'originLocationDescription': _originLocationDescriptionController.text,
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      print(response);
      return response;
    } catch (e) {
      throw Exception('Failed to submit evidence data');
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _containerTypeController.dispose();
    _itemTypeController.dispose();
    _descriptionController.dispose();
    _originCoordinatesController.dispose();
    _originLocationDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Page'),
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                TextFormField(
                  controller: _idController,
                  decoration: InputDecoration(labelText: 'ID'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the ID';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedContainerType,
                  decoration: InputDecoration(labelText: 'Container Type'),
                  items: _containerTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedContainerType = newValue;
                      _containerTypeController.text = newValue!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a container type';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _itemTypeController,
                  decoration: InputDecoration(labelText: 'Item Type'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the item type';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    return null; // Description is optional
                  },
                ),
                TextFormField(
                  controller: _originCoordinatesController,
                  decoration: InputDecoration(labelText: 'Origin Coordinates'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the origin coordinates';
                    }
                    return null;
                  },
                ),
                if (_isFetchingLocation)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                TextFormField(
                  controller: _originLocationDescriptionController,
                  decoration:
                      InputDecoration(labelText: 'Origin Location Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the origin location description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Back'),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final response = await submitEvidenceData();
                            // Log response
                            print(response.body);

                            if (response.statusCode == 201) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Evidence added',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        CheckAnimation(
                                          size: 200, // Adjusted size to make the animation smaller
                                          onComplete: () {
                                            //
                                          },
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => QRScannerPage()),
                                              );
                                            },
                                            child: Text('Scan More'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                                Navigator.push(context,
                                                  MaterialPageRoute(
                                                    builder: (context) => App(),
                                                  ),
                                                );
                                              },
                                              child: Text('Go to Main'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Submission failed',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        FailedAnimation(
                                          size: 200, // Adjusted size to make the animation smaller
                                          onComplete: () {
                                            //
                                          },
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          'Error code: ${response.statusCode}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('Retry'),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => App()),
                                                );
                                              },
                                              child: Text('Go to Main'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        },
                        child: Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
