// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:watch_it/watch_it.dart';

// Project imports:
import 'package:coc/components/listItems/media_evidence_grid.dart';
import 'package:coc/controllers/media_evidence.dart';
import 'package:coc/service/authentication.dart';
import 'package:coc/service/enviroment.dart';

class MediaEvidencePage extends StatelessWidget {
  final List<MediaEvidence> mediaEvidence;

  const MediaEvidencePage({super.key, required this.mediaEvidence});

  @override
  Widget build(BuildContext context) {
    final url = Uri.parse("${EnvironmentConfig.apiUrl}/media/evidence/");
    final headers = {
      'Authorization': di<Authentication>().bearerToken,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Evidence'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MediaEvidenceGrid(
                url: url,
                headers: headers,
                mediaEvidence: mediaEvidence,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
