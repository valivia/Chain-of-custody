// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:coc/components/listItems/case_user.dart';
import 'package:coc/controllers/case_user.dart';
import 'package:coc/pages/lists/full_case_user_list.dart';

class LimCaseUserList extends StatelessWidget {
  const LimCaseUserList({
    super.key,
    required this.itemCount,
    required this.caseUsers,
  });

  final int itemCount;
  final List<CaseUser> caseUsers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // List
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(0),
          itemCount: min(itemCount, caseUsers.length),
          itemBuilder: (context, index) {
            final caseUser = caseUsers[index];
            return CaseUserListItem(caseUser: caseUser);
          },
        ),

        // View All Button
        if (caseUsers.length > itemCount)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(10),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CaseUserListView(users: caseUsers),
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
                  "${caseUsers.length.toString()} total",
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
      ],
    );
  }
}
