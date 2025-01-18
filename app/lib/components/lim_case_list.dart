import 'package:flutter/material.dart';
import 'package:coc/controllers/case.dart';
import 'package:coc/components/full_case_list.dart';
import 'package:coc/components/case_button.dart';

class LimCaseList extends StatelessWidget {
  const LimCaseList({super.key, required this.displayedCaseItemsCount});
  final int displayedCaseItemsCount;

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
                final displayedCaseItems = caseList.take(displayedCaseItemsCount).toList();
                return Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: displayedCaseItems.length,
                      itemBuilder: (context, index) {
                        final caseItem = displayedCaseItems[index];
                        return caseButton(context, caseItem);
                      },
                    ),
                    if (caseList.length > displayedCaseItems.length)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(10),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CaseListView(caseList: caseList),
                              ),
                            );
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.arrow_forward),
                              SizedBox(width: 10),
                              Text('View All'),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}