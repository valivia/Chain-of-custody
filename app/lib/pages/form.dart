import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FormPage extends StatefulWidget {
  final Map<String, dynamic> scannedData;

  FormPage({required this.scannedData});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
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

    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, don't continue
      setState(() {
        _isFetchingLocation = false;
      });
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, don't continue
        setState(() {
          _isFetchingLocation = false;
        });
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, don't continue
      setState(() {
        _isFetchingLocation = false;
      });
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can continue
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _originCoordinatesController.text =
          '${position.latitude}, ${position.longitude}';
      _isFetchingLocation = false;
    });
  }

  Future<http.Response> submitEvidenceData() {
    final url = Uri.parse('https://coc.hootsifer.com/evidence/tag');
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImNtNGsxYXlvcDAwMDB2ZDA4ZnliMXdsbjYiLCJmaXJzdE5hbWUiOiJUaGlqcyIsImxhc3ROYWlIjoiU3RvayIsImVtYWlsIjoidGhpanNAaG9vdHNpZmVyLmNvbSIsImlhdCI6MTczNDQ1Njg2NCwiZXhwIjoxNzM0NDYwNDY0fQ.Vt7yUkPnLoFClV8jMHk2fcbaSo0uW3sHM64Tp3elIMI',
    };
    final body = jsonEncode({
      'id': _idController.text,
      'containerType': _selectedContainerType,
      'itemType': _itemTypeController.text,
      'description': _descriptionController.text,
      'originCoordinates': _originCoordinatesController.text,
      'originLocationDescription': _originLocationDescriptionController.text,
    });
    return http.post(
      url,
      headers: headers,
      body: body,
    );
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
      appBar: AppBar(title: Text('Form Page')),
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
                  decoration: InputDecoration(labelText: 'Origin Location Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the origin location description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Back'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final response = await submitEvidenceData();
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Submit'),
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