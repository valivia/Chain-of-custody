// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:watch_it/watch_it.dart';

// Project imports:
import 'package:coc/components/key_value.dart';
import 'package:coc/components/local_store.dart';
import 'package:coc/components/popups.dart';
import 'package:coc/controllers/case.dart';
import 'package:coc/controllers/tagged_evidence.dart';
import 'package:coc/main.dart';
import 'package:coc/service/api_service.dart';
import 'package:coc/service/location.dart';
import 'package:coc/utility/helpers.dart';

Function(BuildContext, String) navigateToEvidenceCreate(Case caseItem) {
  onscan(BuildContext context, String code) {
    Navigator.pushReplacement(
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

  const RegisterEvidencePage({
    super.key,
    required this.evidenceId,
    required this.caseItem,
  });

  @override
  RegisterEvidencePageState createState() => RegisterEvidencePageState();
}

class RegisterEvidencePageState extends State<RegisterEvidencePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _idController;
  late TextEditingController _itemTypeController;
  late TextEditingController _descriptionController;
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
    _originLocationDescriptionController = TextEditingController();

    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isFetchingLocation = true;
    });

    try {
      _position = await di<LocationService>()
          .getCurrentLocation(desiredAccuracy: LocationAccuracy.lowest);

      if (mounted) {
        setState(() {
          _isFetchingLocation = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isFetchingLocation = false;
        });
      }
    }
  }

  _onSubmit() async {
    if (_formKey.currentState!.validate()) {
        try {
          await TaggedEvidence.fromForm(
            id: _idController.text,
            caseItem: widget.caseItem,
            containerType: ContainerType.values.byName(_selectedContainerType),
            itemType: _itemTypeController.text,
            description: _descriptionController.text,
            originCoordinates: LatLng(_position.latitude, _position.longitude),
            originLocationDescription:
                _originLocationDescriptionController.text,
          );

          showSuccessDialog(
            navigatorKey.currentContext!,
            'Evidence submitted successfully',
            widget.caseItem,
          );
        } on ApiException catch (e) {
          showFailureDialog(
            navigatorKey.currentContext!,
            'Failed to submit evidence data:\n${e.message.toString()}',
            widget.caseItem,
          );
        } catch (e) {
          showFailureDialog(
            navigatorKey.currentContext!,
            'An error occurred:\n$e',
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
    _originLocationDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Evidence'),
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
                // ID
                KeyValue(
                  keyText: 'ID',
                  value: widget.evidenceId,
                ),
                const SizedBox(height: 8),
                // Location
                if (_isFetchingLocation) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ] else ...[
                  KeyValue(
                    keyText: "Latitude",
                    value: _position.latitude.toString(),
                  ),
                  KeyValue(
                    keyText: "Longitude",
                    value: _position.longitude.toString(),
                  ),
                ],
                const SizedBox(height: 20),
                // ##### Inputs #####

                // Container Type
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
                  validator: (value) => validateField(value, 'container type'),
                ),

                // Item Type
                TextFormField(
                  controller: _itemTypeController,
                  decoration: const InputDecoration(labelText: 'Item Type'),
                  validator: (value) => validateField(value, 'item type'),
                ),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) => null,
                ),

                // Origin Location Description
                TextFormField(
                  controller: _originLocationDescriptionController,
                  decoration: const InputDecoration(
                      labelText: 'Origin Location Description'),
                  validator: (value) => validateField(value, 'origin location'),
                ),

                // ##### Buttons #####
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
                        onPressed: _onSubmit,
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
