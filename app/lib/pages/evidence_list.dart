import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:coc/service/evidence.dart';

class EvidenceListView extends StatelessWidget {
  const EvidenceListView({super.key});

  @override
  Widget build(BuildContext context) {
    final evidenceItemListFuture = Evidence.fetchEvidence();
    log('Type of evidenceItemListFuture: ${evidenceItemListFuture.runtimeType}');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Evidence"),
      ),
      body: FutureBuilder<List<Evidence>>(
        future: evidenceItemListFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error occurred'),
            );
          } else if (snapshot.hasData) {
            return EvidenceList(evidenceItems: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class EvidenceList extends StatelessWidget {
  const EvidenceList({super.key, required this.evidenceItems});

  final List<Evidence> evidenceItems;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: evidenceItems.length,
      itemBuilder: (context, index) {
        return Text(evidenceItems[index].evidenceID);
      },
    );
  }
}
