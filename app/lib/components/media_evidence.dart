import 'package:flutter/material.dart';
import 'package:coc/controllers/media_evidence.dart';

Widget mediaEvidenceView({required List<MediaEvidence> mediaEvidence, required String token}) {
  final url = Uri.parse("https://coc.hootsifer.com/media/evidence/");
  final headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': token,
  };

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Media Evidence',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Total: ${mediaEvidence.length}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      GridView.builder(
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
                  builder: (context) => MediaPreview(imageUrl: url.toString() + mediaEvidence[index].id),
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