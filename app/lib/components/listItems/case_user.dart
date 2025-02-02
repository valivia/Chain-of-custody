// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:coc/controllers/case_user.dart';

class CaseUserListItem extends StatelessWidget {
  final CaseUser caseUser;

  const CaseUserListItem({
    super.key,
    required this.caseUser,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme aTextTheme = Theme.of(context).textTheme;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8),
      ),
      //TODO: Add user to case functions
      onPressed: () {},
      child: Row(
        children: [
          const Icon(
            Icons.person,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          Text(caseUser.fullName, style: aTextTheme.bodyMedium,),
        ],
      ),
    );
  }
}
