// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:coc/components/listItems/case_user.dart';
import 'package:coc/controllers/case_user.dart';

class CaseUserListView extends StatelessWidget {
  const CaseUserListView({super.key, required this.users});
  final List<CaseUser> users;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Handlers"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CaseUserList(users: users),
      ),
    );
  }
}

class CaseUserList extends StatelessWidget {
  const CaseUserList({super.key, required this.users});
  final List<CaseUser> users;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final caseUser = users[index];
              return CaseUserListItem(caseUser: caseUser);
            },
          ),
        ),
      ],
    );
  }
}
