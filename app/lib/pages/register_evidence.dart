import 'package:coc/main.dart';
import 'package:coc/service/authentication.dart';
import 'package:coc/service/location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:coc/components/local_store.dart';
import 'package:coc/components/popups.dart'; // Import the popups.dart file

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
        await globalState<LocationService>().getCurrentLocation(desiredAccuracy: LocationAccuracy.lowest);
    setState(() {
      _originCoordinatesController.text =
          '${position.latitude}, ${position.longitude}';
      _isFetchingLocation = false;
    });
  }

  Future<Map<String, dynamic>> submitEvidenceData() async {
    final url = Uri.parse('https://coc.hootsifer.com/evidence/tag');
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': await Authentication.getBearerToken(),
    };
    final body = {
      'id': _idController.text,
      'caseId': "cm5v833zu0000vv2if2t2z3yh",
      'containerType': 1,
      'itemType': _itemTypeController.text,
      'description': _descriptionController.text,
      'originCoordinates': _originCoordinatesController.text,
      'originLocationDescription': _originLocationDescriptionController.text,
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      return {'response': response, 'request': {'url': url.toString(), 'headers': headers, 'body': body}};
    } catch (e) {
      return {'response': http.Response('Error: $e', 500), 'request': {'url': url.toString(), 'headers': headers, 'body': body}};
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: _idController,
                  decoration: const InputDecoration(labelText: 'ID'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the ID';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedContainerType,
                  decoration: const InputDecoration(labelText: 'Container Type'),
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
                  decoration: const InputDecoration(labelText: 'Item Type'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the item type';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    return null; // Description is optional
                  },
                ),
                TextFormField(
                  controller: _originCoordinatesController,
                  decoration: const InputDecoration(labelText: 'Origin Coordinates'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the origin coordinates';
                    }
                    return null;
                  },
                ),
                if (_isFetchingLocation)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                TextFormField(
                  controller: _originLocationDescriptionController,
                  decoration:
                      const InputDecoration(labelText: 'Origin Location Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the origin location description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Back'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            bool isConnected = await LocalStore.hasInternetConnection();
                            Map<String, dynamic> result = await submitEvidenceData();
                            http.Response response = result['response'];
                            Map<String, dynamic> requestData = result['request'];
                            String evidenceKey = requestData['body']['id']; // Generate a unique key

                            if (isConnected) {
                              // Handle response status code
                              if (response.statusCode == 401) {
                                showFailureDialog(context, 'Unauthorized access. Please log in again.');
                              } else if (response.statusCode == 201) {
                                showSuccessDialog(context, 'Evidence submitted successfully');
                              } else {
                                showFailureDialog(context, 'Failed to submit evidence data: ${response.statusCode}');
                              }
                            } else {
                              // Save evidence locally
                              requestData['body']['madeOn'] = DateTime.now().toIso8601String();
                              await LocalStore.saveApiResponse(evidenceKey, requestData);
                              showSuccessDialog(context, 'Evidence saved locally');
                            }
                          }
                        },
                        child: const Text('Submit'),
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
