// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:watch_it/watch_it.dart';

// Project imports:
import 'package:coc/components/listItems/media_evidence_grid.dart';
import 'package:coc/controllers/media_evidence.dart';
import 'package:coc/pages/lists/full_media_evidence.dart';
import 'package:coc/service/authentication.dart';
import 'package:coc/service/enviroment.dart';

class LimMediaEvidenceList extends StatelessWidget {
  const LimMediaEvidenceList({
    super.key,
    required this.itemCount,
    required this.mediaEvidence,
  });

  final int itemCount;
  final List<MediaEvidence> mediaEvidence;

  @override
  Widget build(BuildContext context) {
    final url = Uri.parse("${EnvironmentConfig.apiUrl}/media/evidence/");
    final headers = {
      'Authorization': di<Authentication>().bearerToken,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
        ),
        MediaEvidenceGrid(
          url: url,
          headers: headers,
          mediaEvidence: mediaEvidence,
        ),
        if (mediaEvidence.length > itemCount)
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
}
