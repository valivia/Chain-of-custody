import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:coc/pages/image_gallery.dart'; // Import the new page
import 'package:coc/pages/scanner.dart'; // Import the QR scanner page

class PictureTakingPage extends StatefulWidget {
  const PictureTakingPage({super.key});

  @override
  _PictureTakingPageState createState() => _PictureTakingPageState();
}

class _PictureTakingPageState extends State<PictureTakingPage> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(cameras![0], ResolutionPreset.high);
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
      final String filePath = '$pictureDirectory/${DateTime.now().millisecondsSinceEpoch}.jpg';

      try {
        XFile picture = await _cameraController!.takePicture();
        await picture.saveTo(filePath);
        print('Picture saved to $filePath');

        // Check if the file exists
        if (await File(filePath).exists()) {
          print('File exists at $filePath');
        } else {
          print('File does not exist at $filePath');
        }
      } catch (e) {
        print('Error taking picture: $e');
      }
    } else {
      print('Storage permission not granted');
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
      appBar: AppBar(title: const Text('Take a Picture')),
      body: Center(
        child: Container(
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
                  MaterialPageRoute(builder: (context) => ImageGalleryPage()),
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
                      color: Theme.of(context).scaffoldBackgroundColor, // Match the background color
                    ),
                    child: Center(
                      child: Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color.fromARGB(255, 241, 238, 238),
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
                  MaterialPageRoute(builder: (context) => QRScannerPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}