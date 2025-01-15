import 'package:flutter/material.dart';
import 'package:coc/controllers/media_evidence.dart';
import 'package:coc/components/full_media_evidence.dart';

Widget limMediaEvidenceView({
  required BuildContext context,
  required List<MediaEvidence> mediaEvidence,
  required String token,
}) {
  final url = Uri.parse("https://coc.hootsifer.com/media/evidence/");
  final headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': token,
  };
  const int displayMediaCount = 4;
  final displayedMediaItems = mediaEvidence.take(displayMediaCount).toList();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.all(8.0),
      ),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: displayedMediaItems.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MediaPreview(
                    imageUrl: url.toString() + displayedMediaItems[index].id,
                  ),
                ),
              );
            },
            child: ClipRect(
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image.network(
                  url.toString() + displayedMediaItems[index].id,
                  headers: headers,
                ),
              ),
            ),
          );
        },
      ),
      if (mediaEvidence.length > displayedMediaItems.length)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(10),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MediaEvidencePage(
                    mediaEvidence: mediaEvidence,
                    token: token,
                  ),
                ),
              );
            },
            child: Row(
              children: [
                const Icon(Icons.arrow_forward),
                const SizedBox(width: 10),
                const Text('View All'),
                const Spacer(),
                Text(
                  "${mediaEvidence.length.toString()} total",
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
    ],
  );
}

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
