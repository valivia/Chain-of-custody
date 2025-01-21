// Flutter imports:
import 'package:coc/controllers/case_user.dart';
import 'package:flutter/material.dart';

class CaseUserListItem extends StatelessWidget {
  final CaseUser caseUser;

  const CaseUserListItem({
    super.key,
    required this.caseUser,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8),
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
    );
  }
}
