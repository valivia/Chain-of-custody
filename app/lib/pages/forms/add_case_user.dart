// Flutter imports:
import 'dart:convert';
import 'dart:developer';

import 'package:coc/components/key_value.dart';
import 'package:coc/controllers/case_user.dart';
import 'package:coc/controllers/user.dart';
import 'package:coc/main.dart';
import 'package:coc/service/api_service.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:coc/controllers/case.dart';

Function(BuildContext, String) navigateToCaseUserCreate(Case caseItem) {
  Future<void> onscan(BuildContext context, String code) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterCaseUser(
          input: code,
          caseItem: caseItem,
        ),
      ),
    );
  }

  return onscan;
}

class RegisterCaseUser extends StatefulWidget {
  final String input;
  final Case caseItem;

  const RegisterCaseUser({
    super.key,
    required this.input,
    required this.caseItem,
  });

  @override
  RegisterCasePageState createState() => RegisterCasePageState();
}

class RegisterCasePageState extends State<RegisterCaseUser> {
  UserScannable? user;

  @override
  void initState() {
    try {
      user = UserScannable.fromJson(jsonDecode(widget.input));
    } catch (e) {
      log(e.toString());
    }

    super.initState();
  }

  Future<void> submit() async {
    String title = "Success";
    String message = "Case user registered successfully!";

    try {
      await CaseUser.fromForm(
        userId: user!.id,
        permissions: allPermissions().toRadixString(2),
        caseItem: widget.caseItem,
      );
    } on ApiException catch (error) {
      title = "Error";
      if (error.code == 404) {
        message = "User not found.";
      } else {
        message = error.message;
      }
    } catch (error) {
      title = "Error";
      message = error.toString();
    }

    showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // remove till back on case page
                Navigator.popUntil(context, ModalRoute.withName('/case'));
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Case User"),
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user == null) ...[
              const Text("Invalid QR code. Please try again."),
            ] else ...[
              // Info
              const SizedBox(height: 20),
              KeyValue(keyText: "Name", value: user!.name),
              const SizedBox(height: 8),
              KeyValue(keyText: "id", value: user!.id),
            ],

            const SizedBox(height: 20),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Back'),
                  ),
                ),
                if (user != null) ...[
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await submit();
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
