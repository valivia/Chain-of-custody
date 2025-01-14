import 'package:flutter/material.dart';
import 'dart:io';
import 'package:coc/components/local_store.dart';

class ImageGalleryPage extends StatelessWidget {
  const ImageGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: LocalStore.getAllData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading images'));
        } else {
          var pictures = snapshot.data!['pictures'] as List<Map<String, dynamic>>;

          return Scaffold(
            appBar: AppBar(title: const Text('Image Gallery')),
            body: pictures.isEmpty
                ? const Center(child: Text('No images found'))
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: pictures.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImagePreviewPage(imageFile: File(pictures[index]['filePath'])),
                            ),
                          );
                        },
                        child: ClipRect(
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Image.file(File(pictures[index]['filePath'])),
                            ),
                          ),
                      );
                    },
                  ),
          );
        }
      },
    );
  }
}

class ImagePreviewPage extends StatelessWidget {
  final File imageFile;

  const ImagePreviewPage({super.key, required this.imageFile});

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