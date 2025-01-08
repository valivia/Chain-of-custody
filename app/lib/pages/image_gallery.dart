import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ImageGalleryPage extends StatefulWidget {
  @override
  _ImageGalleryPageState createState() => _ImageGalleryPageState();
}

class _ImageGalleryPageState extends State<ImageGalleryPage> {
  List<File> _images = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String pictureDirectory = '${appDirectory.path}/Pictures';
    final Directory dir = Directory(pictureDirectory);
    final List<FileSystemEntity> entities = await dir.list().toList();
    final List<File> files = entities.whereType<File>().toList();

    setState(() {
      _images = files;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Gallery')),
      body: _images.isEmpty
          ? const Center(child: Text('No images found'))
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImagePreviewPage(imageFile: _images[index]),
                      ),
                    );
                  },
                  child: ClipRect(
                    child: Container(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Image.file(_images[index]),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class ImagePreviewPage extends StatelessWidget {
  final File imageFile;

  const ImagePreviewPage({Key? key, required this.imageFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Preview')),
      body: Center(
        child: Image.file(imageFile),
      ),
    );
  }
}