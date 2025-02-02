// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:coc/components/button.dart';
import 'package:coc/components/evidence_base_details.dart';
import 'package:coc/components/lists/transfer_history.dart';
import 'package:coc/components/location_display.dart';
import 'package:coc/controllers/tagged_evidence.dart';

class EvidenceDetailView extends StatelessWidget {
  final TaggedEvidence evidence;

  const EvidenceDetailView({super.key, required this.evidence});

  @override
  Widget build(BuildContext context) {
    TextTheme aTextTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          evidence.itemType, style: aTextTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Button(
              title: "View location",
              icon: Icons.map,
              onTap: () {
                showModalBottomSheet(
                  showDragHandle: true,
                  context: context,
                  builder: (BuildContext context) {
                    return MapPointerBottomSheet(
                      // title: Text("Origin", style: aTextTheme.displaySmall,),
                      title: "Origin",
                      userId: evidence.userId,
                      createdAt: evidence.createdAt!,
                      location: evidence.originCoordinates,
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 32),
            EvidenceDetails(evidence: evidence),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Transfers',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  LimTransferHistoryView(
                      transfers: evidence.transfers, itemCount: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
