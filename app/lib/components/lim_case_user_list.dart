import 'package:flutter/material.dart';
import 'package:coc/controllers/case_user.dart';
import 'package:coc/components/full_case_user_list.dart';

Widget limCaseUserList(BuildContext context, List<CaseUser> caseUsers) {
  const int displayItemCount = 3;
  final displayedCaseUsers = caseUsers.take(displayItemCount).toList();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Handlers on case',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Total: ${caseUsers.length}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: displayedCaseUsers.length,
        itemBuilder: (context, index) {
          final caseUser = displayedCaseUsers[index];
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(10),
            ),
            onPressed: () {},
            child: Row(
              children: [
                const Icon(Icons.person),
                const SizedBox(width: 10),
                Text("${caseUser.firstName} ${caseUser.lastName}"),
              ],
            ),
          );
        },
      ),
      if (caseUsers.length > displayedCaseUsers.length)
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CaseUserList(users: caseUsers),
              ),
            );
          },
          child: const Text('View All Users'),
        ),
    ],
  );
}
