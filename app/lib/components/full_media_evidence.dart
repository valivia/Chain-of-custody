import 'package:coc/main.dart';
import 'package:coc/service/authentication.dart';
import 'package:coc/service/enviroment.dart';
import 'package:flutter/material.dart';
import 'package:coc/controllers/media_evidence.dart';
import 'package:coc/components/media_grid_builder.dart';

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildMediaGrid(
                url: url,
                headers: headers,
                mediaItems: mediaEvidence,
              ),
            ],
          ),
        ),
      ),
    );
  }
}