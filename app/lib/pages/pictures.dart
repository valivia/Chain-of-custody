// Dart imports:
import 'dart:developer';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';

// Project imports:
import 'package:coc/components/local_store.dart';
import 'package:coc/controllers/case.dart';
import 'package:coc/controllers/media_evidence.dart';
import 'package:coc/main.dart';
import 'package:coc/pages/forms/register_evidence.dart';
import 'package:coc/pages/lists/full_media_evidence.dart';
import 'package:coc/pages/scanner.dart';
import 'package:coc/service/api_service.dart';
import 'package:coc/service/location.dart';
import 'package:coc/utility/helpers.dart';

class PictureTakingPage extends StatefulWidget {
  final Case caseItem;

  const PictureTakingPage({
    super.key,
    required this.caseItem,
  });

  @override
  PictureTakingPageState createState() => PictureTakingPageState();
}

class PictureTakingPageState extends State<PictureTakingPage> {
  CameraController? _cameraController;
  late List<CameraDescription> cameras;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    _cameraController =
        CameraController(cameras[0], ResolutionPreset.high, enableAudio: false);
    await _cameraController!.initialize();
    setState(() {});
  }

  Future<void> takePicture() async {
    if (!_cameraController!.value.isInitialized) {
      return;
    }

    XFile picture = await _cameraController!.takePicture();

    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String pictureDirectory = '${appDirectory.path}/Pictures';
    await Directory(pictureDirectory).create(recursive: true);
    final String filePath =
        '$pictureDirectory/${DateTime.now().millisecondsSinceEpoch}.jpg';

    try {
      // Set flash mode to auto or always before taking a picture
      _cameraController!
          .setFlashMode(_isFlashOn ? FlashMode.always : FlashMode.off);

      await picture.saveTo(filePath);

      // Get current coordinates
      Position position = await LocationService()
          .getCurrentLocation(desiredAccuracy: LocationAccuracy.lowest);

      final LatLng coordinates = LatLng(position.latitude, position.longitude);

      // Attempt to send the picture to the server
      bool uploadSuccess = await _uploadPicture(
        filePath,
        coordinates,
      );
      if (!uploadSuccess) {
        // Save picture metadata to Hive if upload fails
        await LocalStore.savePictureMetadata(
          filePath,
          widget.caseItem.id,
          coordinatesToString(coordinates),
        );
      }

      // Show feedback when a picture is taken without flash
      if (!_isFlashOn) {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Picture saved')),
        );
      }
    } catch (e) {
      log('Error taking picture: $e');
    }
  }

  Future<bool> _uploadPicture(String filePath, LatLng coordinates) async {
    try {
      await MediaEvidence.fromForm(
        filePath: filePath,
        caseItem: widget.caseItem,
        originCoordinates: coordinates,
      );

      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(content: Text('Picture saved to server')),
      );

      return true;
    } on ApiException catch (e) {
      log('Failed to upload picture:\n${e.message}');
      return false;
    } catch (e) {
      log('Error uploading picture:\n$e');
      return false;
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    TextTheme aTextTheme = Theme.of(context).textTheme;

    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Take a Picture', style: aTextTheme.headlineMedium,),
        actions: [
          IconButton(
            icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
            onPressed: () {
              setState(() {
                _isFlashOn = !_isFlashOn;
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          child: AspectRatio(
            aspectRatio: _cameraController!.value.aspectRatio,
            child: CameraPreview(_cameraController!),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 120.0, // Set a fixed height for the bottom navigation bar
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.photo_library),
              iconSize: 30.0, // Set the icon size
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MediaEvidencePage(
                        mediaEvidence: widget.caseItem.mediaEvidence),
                  ),
                );
              },
            ),
            GestureDetector(
              onTap: takePicture,
              child: Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    width: 4.0,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 75.0,
                    height: 75.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context)
                          .scaffoldBackgroundColor, // Match the background color
                    ),
                    child: Center(
                      child: Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 241, 238, 238),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.qr_code_scanner),
              iconSize: 30.0, // Set the icon size
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRScannerPage(
                      onScan: navigateToEvidenceCreate(widget.caseItem),
                      title: 'Scan QR Code',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
