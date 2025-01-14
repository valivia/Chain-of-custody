import 'package:flutter/material.dart';
import 'package:coc/controllers/media_evidence.dart';

class MediaEvidenceView extends StatelessWidget { 
  const MediaEvidenceView({super.key, required this.mediaEvidence}); 
  final List<MediaEvidence> mediaEvidence;

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Evidence Gallery'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: mediaEvidence.length,
        itemBuilder: (context, index) {
          return Image.network(mediaEvidence[index].id);
        },
      ),
    );
  }



}