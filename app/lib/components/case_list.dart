import 'package:flutter/material.dart';
import 'package:coc/controllers/case.dart';
import 'package:coc/pages/case_detail.dart';

class CaseList extends StatelessWidget {
  const CaseList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cases',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          FutureBuilder<List<Case>>(
            future: Case.fetchCases(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error occurred: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No cases found attached to you'));
              } else {
                final caseList = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: caseList.length,
                  itemBuilder: (context, index) {
                    final caseItem = caseList[index];
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CaseDetailView(caseItem: caseItem),
                          ),
                        );
                      },
                      child: Text("Title: ${caseItem.title}, \nID: ${caseItem.id}"),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
