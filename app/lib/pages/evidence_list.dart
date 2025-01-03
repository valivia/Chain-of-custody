import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:coc/service/evidence.dart';

class EvidenceListView extends StatelessWidget {
  const EvidenceListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evidence List'),
      ),
      body: FutureBuilder<List<Evidence>>(
        future: Evidence.fetchEvidence(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error occured: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No evidence data found'));
          } else {
            final evidenceList = snapshot.data!;
            return ListView.builder(
              itemCount: evidenceList.length,
              itemBuilder: (context, index) {
                final evidence = evidenceList[index];
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                  ),
                  onPressed: () {
                    // TODO: Handle item click
                    log('Clicked on ${evidence.evidenceID}');
                  },
                  child: Text("ID: ${evidence.evidenceID}"),
                );
              },
            );
          }
        },
      ),
    );
  }
}
