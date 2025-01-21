import 'package:coc/controllers/media_evidence.dart';
import 'package:coc/components/media_preview.dart';
import 'package:flutter/material.dart';

Widget buildMediaGrid({
  required List<MediaEvidence> mediaItems,
  required Uri url,
  required Map<String, String> headers,
}) {
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 4.0,
      mainAxisSpacing: 4.0,
    ),
    itemCount: mediaItems.length,
    itemBuilder: (context, index) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MediaPreview(
                imageUrl: url.toString() + mediaItems[index].id,
              ),
            ),
          );
        },
        child: ClipRect(
          child: FittedBox(
            fit: BoxFit.cover,
            child: Image.network(
              url.toString() + mediaItems[index].id,
              headers: headers,
            ),
          ),
        ),
      );
    },
  );
}
