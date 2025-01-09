import 'dart:math';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:coc/controllers/case.dart';
import 'package:coc/controllers/user.dart';
import 'package:coc/controllers/case_user.dart';

class CaseUserListView extends StatelessWidget {
  const CaseUserListView({super.key, required this.users});
  final List<CaseUser> users;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CaseUserList(users: users),
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
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Handlers",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Flexible(
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final handler = users[index];
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                ),
                onPressed: () {},
                child: Row(
                  children: [
                    const Icon(Icons.person),
                    const SizedBox(width: 10),
                    Text(handler.userId),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
