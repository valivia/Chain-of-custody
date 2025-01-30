// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:coc/controllers/case_user.dart';

class UserDisplayBox extends StatelessWidget {
  final CaseUser caseUser;

  const UserDisplayBox({
    super.key,
    required this.caseUser,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(caseUser.fullName, textAlign: TextAlign.center),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text('Lastname: ${caseUser.lastName}'),
              const SizedBox(height: 5),
              Text('Firstname: ${caseUser.firstName}'),
              const SizedBox(height: 5),
              Text('Email: ${caseUser.email}'),
              const SizedBox(height: 5),
              Text('UserID: ${caseUser.userId}'),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
// Maybe only show if logged in user has right perms? but idk how
      floatingActionButton: FloatingActionButton.extended(
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
