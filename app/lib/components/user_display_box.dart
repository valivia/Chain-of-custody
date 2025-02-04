// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:watch_it/watch_it.dart';

// Project imports:
import 'package:coc/components/key_value.dart';
import 'package:coc/components/tag.dart';
import 'package:coc/controllers/case_user.dart';
import 'package:coc/service/data.dart';

class UserDisplayBox extends StatelessWidget {
  final CaseUser caseUser;

  const UserDisplayBox({
    super.key,
    required this.caseUser,
  });

  @override
  Widget build(BuildContext context) {
    final currentCase = di<DataService>().currentCase;
    TextTheme aTextTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          caseUser.fullName,
          textAlign: TextAlign.center,
          style: aTextTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Case user Information', style: aTextTheme.displayLarge),
                  const SizedBox(height: 10),
                  KeyValue(keyText: "First name", value: caseUser.firstName),
                  const SizedBox(height: 5),
                  KeyValue(keyText: "Last name", value: caseUser.lastName),
                  const SizedBox(height: 5),
                  KeyValue(keyText: "Email", value: caseUser.email),
                  const SizedBox(height: 5),
                  KeyValue(keyText: "ID", value: caseUser.userId),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Permissions',
                    style: aTextTheme.displayLarge,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    children: [
                      ...caseUser.permissionStrings
                          .map((permission) => Tag(value: permission))
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: currentCase?.canIUse(CasePermission.manage)
          ? FloatingActionButton.extended(
              onPressed: () {
                // replace with actual content
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Button Pressed'),
                      content: const Text('You have pressed the edit button.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.edit_document),
              label: const Text('Edit user'),
              tooltip: 'Edit user',
              backgroundColor: Theme.of(context).colorScheme.primary,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
