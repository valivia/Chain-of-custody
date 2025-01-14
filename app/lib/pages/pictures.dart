import 'package:coc/controllers/case.dart';
import 'package:coc/pages/register_evidence.dart';
import 'package:coc/service/location.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:coc/pages/image_gallery.dart';
import 'package:coc/pages/scanner.dart';
import 'package:coc/components/local_store.dart';
import 'package:coc/service/authentication.dart';

class PictureTakingPage extends StatefulWidget {
  final Case caseItem;

  const PictureTakingPage({super.key, required this.caseItem});

  @override
  PictureTakingPageState createState() => PictureTakingPageState();
}

class PictureTakingPageState extends State<PictureTakingPage> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(cameras![0], ResolutionPreset.high,
        enableAudio: false);
    await _cameraController!.initialize();
    setState(() {});
  }

  Future<void> takePicture() async {
    if (!_cameraController!.value.isInitialized) {
      return;
    }

    // Check for storage permissions
    if (await Permission.storage.request().isGranted) {
      final Directory appDirectory = await getApplicationDocumentsDirectory();
      final String pictureDirectory = '${appDirectory.path}/Pictures';
      await Directory(pictureDirectory).create(recursive: true);
      final String filePath =
          '$pictureDirectory/${DateTime.now().millisecondsSinceEpoch}.jpg';

      try {
        // Set flash mode to auto or always before taking a picture
        await _cameraController!
            .setFlashMode(_isFlashOn ? FlashMode.always : FlashMode.off);

        XFile picture = await _cameraController!.takePicture();
        await picture.saveTo(filePath);

        // Get current coordinates
        // TODO: check if lowest is good enuff
        Position position = await LocationService()
            .getCurrentLocation(desiredAccuracy: LocationAccuracy.lowest);
        String coordinates = '${position.latitude},${position.longitude}';

        // Attempt to send the picture to the server
        bool uploadSuccess =
            await _uploadPicture(filePath, widget.caseItem.id, coordinates);
        if (!uploadSuccess) {
          // Save picture metadata to Hive if upload fails
          await LocalStore.savePictureMetadata(
              filePath, widget.caseItem.id, coordinates);
        }

        // Show feedback when a picture is taken without flash
        if (!_isFlashOn) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Picture saved')),
          );
        }
      } catch (e) {
        log('Error taking picture: $e');
      }
    } else {
      log('Storage permission not granted');
    }
  }

  Future<bool> _uploadPicture(
      String filePath, String caseId, String coordinates) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://coc.hootsifer.com/evidence/media'),
      );

      // Add headers including the Bearer token
      request.headers['Authorization'] = await Authentication.getBearerToken();
      request.fields['caseId'] = caseId;
      request.fields['coordinates'] = coordinates;
      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      var response = await request.send();
      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Picture saved to server')),
        );
        return true;
      } else {
        log('Failed to upload picture: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      log('Error uploading picture: $e');
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
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Take a Picture'),
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
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 1,
          child: CameraPreview(_cameraController!),
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
                      builder: (context) => const ImageGalleryPage()),
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
                          )),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
