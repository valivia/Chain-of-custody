// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:coc/controllers/tagged_evidence.dart';
import 'package:coc/main.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:watch_it/watch_it.dart';

// Project imports:
import 'package:coc/components/local_store.dart';
import 'package:coc/components/popups.dart';
import 'package:coc/controllers/case.dart';
import 'package:coc/service/authentication.dart';
import 'package:coc/service/enviroment.dart';
import 'package:coc/service/location.dart';

Function(BuildContext, String) navigateToEvidenceCreate(Case caseItem) {
  onscan(BuildContext context, String code) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterEvidencePage(
            evidenceId: code,
            caseItem: caseItem,
          ),
        ));
  }

  return onscan;
}

class RegisterEvidencePage extends StatefulWidget {
  final String evidenceId;
  final Case caseItem;

  const RegisterEvidencePage(
      {super.key, required this.evidenceId, required this.caseItem});

  @override
  RegisterEvidencePageState createState() => RegisterEvidencePageState();
}

class RegisterEvidencePageState extends State<RegisterEvidencePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _idController;
  late TextEditingController _itemTypeController;
  late TextEditingController _descriptionController;
  late TextEditingController _originCoordinatesController;
  late TextEditingController _originLocationDescriptionController;
  String _selectedContainerType = ContainerType.bag.name;
  bool _isFetchingLocation = false;
  late Position _position;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.evidenceId);
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
    _position = await di<LocationService>()
        .getCurrentLocation(desiredAccuracy: LocationAccuracy.lowest);
    setState(() {
      _position = _position;
      _isFetchingLocation = false;
    });
  }

  Future<Map<String, dynamic>> submitEvidenceData() async {
    final url = Uri.parse('${EnvironmentConfig.apiUrl}/evidence/tag');
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': di<Authentication>().bearerToken,
    };
    final body = {
      'id': _idController.text,
      'caseId': widget.caseItem.id,
      'containerType': _selectedContainerType,
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

  onSubmit() async {
    if (_formKey.currentState!.validate()) {
      bool isConnected = await LocalStore.hasInternetConnection();
      Map<String, dynamic> result = await submitEvidenceData();
      http.Response response = result['response'];
      Map<String, dynamic> requestData = result['request'];
      String evidenceKey = requestData['body']['id'];

      if (isConnected) {
        // Handle response status code
        if (response.statusCode == 401) {
          showFailureDialog(
            navigatorKey.currentContext!,
            'Unauthorized access. Please log in again.',
            widget.caseItem,
          );
        } else if (response.statusCode == 201) {
          showSuccessDialog(
            navigatorKey.currentContext!,
            'Evidence submitted successfully',
            widget.caseItem,
          );
        } else {
          showFailureDialog(
            navigatorKey.currentContext!,
            'Failed to submit evidence data: ${response.statusCode}',
            widget.caseItem,
          );
        }
      } else {
        // Save evidence locally
        requestData['body']['madeOn'] = DateTime.now().toIso8601String();
        await LocalStore.saveApiResponse(evidenceKey, requestData);
        showSuccessDialog(
          navigatorKey.currentContext!,
          'Evidence saved locally',
          widget.caseItem,
        );
      }
    }
  }

  @override
  void dispose() {
    _idController.dispose();
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
                  decoration:
                      const InputDecoration(labelText: 'Container Type'),
                  items: ContainerType.values.map((ContainerType type) {
                    return DropdownMenuItem<String>(
                      value: type.name,
                      child: Text(type.name),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedContainerType = newValue!;
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
                  decoration:
                      const InputDecoration(labelText: 'Origin Coordinates'),
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
                  decoration: const InputDecoration(
                      labelText: 'Origin Location Description'),
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
                        onPressed: onSubmit,
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
