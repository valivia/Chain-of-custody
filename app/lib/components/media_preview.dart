import 'package:flutter/material.dart';

class MediaPreview extends StatelessWidget {
  final String imageUrl;

  const MediaPreview({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Preview')),
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}