import 'package:coc/main.dart';
import 'package:coc/service/authentication.dart';
import 'package:coc/service/enviroment.dart';
import 'package:flutter/material.dart';
import 'package:coc/controllers/media_evidence.dart';

class MediaEvidencePage extends StatelessWidget {
  final List<MediaEvidence> mediaEvidence;

  const MediaEvidencePage({super.key, required this.mediaEvidence});

  @override
  Widget build(BuildContext context) {
    final url = Uri.parse("${EnvironmentConfig.apiUrl}/media/evidence/");
    final headers = {
      'Authorization': globalState<Authentication>().bearerToken,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Evidence'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: mediaEvidence.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MediaPreview(
                              imageUrl:
                                  url.toString() + mediaEvidence[index].id),
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
            ),
          ),
        ],
      ),
    );
  }
}

class MediaPreview extends StatelessWidget {
  final String imageUrl;

  const MediaPreview({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Preview')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}
