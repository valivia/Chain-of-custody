// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:coc/controllers/media_evidence.dart';
import 'package:coc/pages/media_preview.dart';

class MediaEvidenceGrid extends StatelessWidget {
  final List<MediaEvidence> mediaEvidence;
  final Uri url;
  final Map<String, String> headers;

  const MediaEvidenceGrid({
    super.key,
    required this.mediaEvidence,
    required this.url,
    required this.headers,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemCount: mediaEvidence.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MediaPreview(
                  imageUrl: url.toString() + mediaEvidence[index].id,
                ),
              ),
            );
          },
          child: ClipRect(
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image.network(
                url.toString() + mediaEvidence[index].id,
                headers: headers,
              ),
            ),
          ),
        );
      },
    );
  }
}
