import 'package:flutter/material.dart';
import 'package:coc/controllers/case_user.dart';
import 'package:coc/components/full_case_user_list.dart';

Widget caseUserListRemake(BuildContext context, List<CaseUser> caseUsers) {
  final displayedCaseUsers = caseUsers.take(2).toList();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Users on case',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
      if (caseUsers.length > 4)
        ListTile(
          title: const Text('View All'),
          leading: const Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CaseUserList(users: caseUsers),
              ),
            );
          },
        ),
    ],
  );
}
