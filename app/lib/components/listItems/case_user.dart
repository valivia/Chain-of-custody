// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:coc/components/user_display_box.dart';
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
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDisplayBox(caseUser: caseUser),
          ),
        );
      },
      child: Row(
        children: [
          Icon(
            caseUser.hasPermission(CasePermission.manage)
                ? Icons.person
                : Icons.person_outlined,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          Text(
            caseUser.fullName,
            style: aTextTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
