// Flutter imports:
import 'dart:math';

import 'package:flutter/material.dart';

// Project imports:
import 'package:coc/controllers/media_evidence.dart';
import 'package:coc/pages/media_preview.dart';

class MediaEvidenceGrid extends StatelessWidget {
  final List<MediaEvidence> mediaEvidence;
  final Uri url;
  final Map<String, String> headers;
  final int? itemCount;

  const MediaEvidenceGrid({
    super.key,
    required this.mediaEvidence,
    required this.url,
    required this.headers,
    this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(0),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemCount: itemCount != null
          ? min(mediaEvidence.length, itemCount!)
          : mediaEvidence.length,
      itemBuilder: (context, index) {
        final imageUrl = url.toString() + mediaEvidence[index].id;
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MediaPreview(imageUrl: imageUrl),
              ),
            );
          },
          child: ClipRect(
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image.network(
                imageUrl,
                headers: headers,
              ),
            ),
          ),
        );
      },
    );
  }
}
