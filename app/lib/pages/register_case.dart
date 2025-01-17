import 'dart:convert';
import 'package:coc/main.dart';
import 'package:coc/service/authentication.dart';
import 'package:coc/service/enviroment.dart';
import 'package:flutter/material.dart';
import 'package:coc/components/local_store.dart';
import 'package:coc/components/popups.dart';
import 'package:http/http.dart' as http;

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
      'Authorization': globalState<Authentication>().bearerToken,
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Case"),
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: _titleController,
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
                        child: const Text('Back'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            Map<String, dynamic> result = await submitCaseData();
                            http.Response response = result['response'];
                            if (await LocalStore.hasInternetConnection()) {
                              LocalStore.saveCaseData('case', {
                                'title': _titleController.text,
                                'description': _descriptionController.text,
                              });
                              showSuccessDialog(context, 'Case saved locally');
                            } else if (response.statusCode == 401) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Unauthorized'),
                                    content: const Text('You are not authorized to perform this action, check if your logged in.'),
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
                            } else if (response.statusCode == 201) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Success'),
                                    content: const Text('Case registered successfully!'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pushAndRemoveUntil(
                                            MaterialPageRoute(builder: (context) => const HomePage()),
                                            (Route<dynamic> route) => false,
                                          );
                                        },
                                        child: const Text('Home'),
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
                                    title: const Text('Error'),
                                    content: Text('Failed to register case: ${response.body}'),
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
                            }
                          }
                        },
                        child: const Text('Submit'),
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
