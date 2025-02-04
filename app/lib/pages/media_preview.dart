// Flutter imports:
import 'package:flutter/material.dart';

class MediaPreview extends StatelessWidget {
  final String imageUrl;

  const MediaPreview({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    TextTheme aTextTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Image Preview',
            style: aTextTheme.headlineMedium,
          )),
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}
