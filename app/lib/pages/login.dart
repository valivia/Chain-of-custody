// Dart imports:
import 'dart:developer';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:watch_it/watch_it.dart';

// Project imports:
import 'package:coc/main.dart';
import 'package:coc/service/authentication.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailInputController;
  late TextEditingController _passwordInputController;
  late bool _passwordInvisible;
  late bool _isButtonDisabled;

  @override
  void initState() {
    super.initState();
    _emailInputController = TextEditingController();
    _passwordInputController = TextEditingController();
    _passwordInvisible = true;
    _isButtonDisabled = false;
  }

  @override
  void dispose() {
    _emailInputController.dispose();
    _passwordInputController.dispose();
    super.dispose();
  }

  void submit() async {
    // disable login/submit button awaiting response
    setState(() {
      _isButtonDisabled = true;
    });

    if (!_formKey.currentState!.validate()) {
      // Enable login/submit button after response
      setState(() {
        _isButtonDisabled = false;
      });
    }

    try {
      await di<Authentication>().login(
        _emailInputController.text,
        _passwordInputController.text,
      );
    } catch (error) {
      log(" --- Login failed: $error --- ");
      final snackBar = SnackBar(content: Text("Login Failed: \n$error"));
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(snackBar);

      // Enable login/submit button after response
      setState(() {
        _isButtonDisabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Email box
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailInputController,
                  decoration: const InputDecoration(
                    labelText: "email",
                    hintText: "Enter your email",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your signin Email";
                    }
                    return null;
                  },
                  //suggestions enabled, autocorrect disabled
                  enableSuggestions: true,
                  autocorrect: false,
                ),

                // Password box
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordInputController,
                  decoration: InputDecoration(
                      labelText: "password",
                      hintText: "Enter your password",
                      // toggle button for password visibilty
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordInvisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordInvisible = !_passwordInvisible;
                          });
                        },
                      )),
                  // make text unreadable on toggle and disable autocorrect and suggestions
                  obscureText: _passwordInvisible,
                  enableSuggestions: false,
                  autocorrect: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isButtonDisabled ? null : submit,
                        child: const Text('Login'),
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
