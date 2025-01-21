// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:coc/components/full_case_user_list.dart';
import 'package:coc/controllers/case_user.dart';

Widget limCaseUserList(BuildContext context, List<CaseUser> caseUsers) {
  const int displayItemCount = 3;
  final displayedCaseUsers = caseUsers.take(displayItemCount).toList();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: displayedCaseUsers.length,
        itemBuilder: (context, index) {
          final caseUser = displayedCaseUsers[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(10),
              ),
              //TODO: Add user to case functions
              onPressed: () {},
              child: Row(
                children: [
                  const Icon(Icons.person),
                  const SizedBox(width: 10),
                  Text("${caseUser.firstName} ${caseUser.lastName}"),
                ],
              ),
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
