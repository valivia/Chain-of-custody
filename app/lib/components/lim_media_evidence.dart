import 'package:coc/main.dart';
import 'package:coc/service/authentication.dart';
import 'package:coc/service/enviroment.dart';
import 'package:flutter/material.dart';
import 'package:coc/controllers/media_evidence.dart';
import 'package:coc/components/full_media_evidence.dart';
import 'package:coc/components/media_grid_builder.dart';

Widget limMediaEvidenceView({
  required BuildContext context,
  required List<MediaEvidence> mediaEvidence,
}) {
  final url = Uri.parse("${EnvironmentConfig.apiUrl}/media/evidence/");
  final headers = {
    'Authorization': globalState<Authentication>().bearerToken,
  };
  const int displayMediaCount = 4;
  final displayedMediaItems = mediaEvidence.take(displayMediaCount).toList();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      ),
      buildMediaGrid(url: url, headers: headers, mediaItems:  displayedMediaItems),
      if (mediaEvidence.length > displayedMediaItems.length)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
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
