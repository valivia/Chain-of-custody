// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:http/http.dart' as http;
import 'package:watch_it/watch_it.dart';

// Project imports:
import 'package:coc/controllers/case.dart';
import 'package:coc/main.dart';
import 'package:coc/service/authentication.dart';
import 'package:coc/service/data.dart';
import 'package:coc/service/enviroment.dart';

class RegisterCase extends StatefulWidget {
  const RegisterCase({super.key});

  @override
  RegisterCasePageState createState() => RegisterCasePageState();
}

class RegisterCasePageState extends State<RegisterCase> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  Future<Map<String, dynamic>> submitCaseData() async {
    final url = Uri.parse('${EnvironmentConfig.apiUrl}/case');
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': di<Authentication>().bearerToken,
    };
    final body = {
      'title': _titleController.text,
      'description': _descriptionController.text,
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      final caseItem = Case.fromJson(jsonDecode(response.body)["data"]);
      di<DataService>().upsertCase(caseItem);

      return {
        'response': response,
        'request': {'url': url.toString(), 'headers': headers, 'body': body}
      };
    } catch (e) {
      return {
        'response': http.Response('Error: $e', 500),
        'request': {'url': url.toString(), 'headers': headers, 'body': body}
      };
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme aTextTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Register Case",
          style: aTextTheme.headlineMedium,
        ),
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: _titleController,
                  style: aTextTheme.displaySmall,
                  decoration: const InputDecoration(labelText: "Title"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a title!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _descriptionController,
                  style: aTextTheme.displaySmall,
                  decoration: const InputDecoration(labelText: "Description"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a (brief) description";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 48.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Back',
                          style: aTextTheme.bodyLarge,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            Map<String, dynamic> result =
                                await submitCaseData();
                            http.Response response = result['response'];
                            if (response.statusCode == 401) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Unauthorized',
                                      style: aTextTheme.displayLarge,
                                    ),
                                    content: Text(
                                      'You are not authorized to perform this action, check if your logged in.',
                                      style: aTextTheme.displayMedium,
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'OK',
                                          style: aTextTheme.bodyLarge,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else if (response.statusCode == 201) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Success',
                                      style: aTextTheme.displayLarge,
                                    ),
                                    content: Text(
                                      'Case registered successfully!',
                                      style: aTextTheme.displayMedium,
                                    ),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const HomePage()),
                                            (Route<dynamic> route) => false,
                                          );
                                        },
                                        child: Text('Home',
                                            style: aTextTheme.bodyLarge),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Error',
                                      style: aTextTheme.displayLarge,
                                    ),
                                    content: Text(
                                      'Failed to register case: ${response.body}',
                                      style: aTextTheme.displayMedium,
                                    ),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'OK',
                                          style: aTextTheme.bodyLarge,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        },
                        child: Text(
                          'Submit',
                          style: aTextTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
