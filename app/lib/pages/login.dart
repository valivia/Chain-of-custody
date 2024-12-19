import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:coc/service/authentication.dart';
import 'package:coc/pages/debug.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

void setup() {
  getIt.registerSingleton<Authentication>(Authentication());
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailInputController;
  late TextEditingController _passwordInputController;
  late bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    _emailInputController = TextEditingController();
    _passwordInputController = TextEditingController();
    _passwordVisible = false;
  }

  @override
  void dispose() {
    _emailInputController.dispose();
    _passwordInputController.dispose();
    super.dispose();
  }

  void submit() async {
    if (!_formKey.currentState!.validate()) {
      log(" --- Form validation failed --- ");
      const snackBar = SnackBar(content: Text('Please fill in all fields'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    log(" --- Form Validation Succesfull ---");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logging in...")),
    );

    try {
      bool loginResponse = await Authentication.login(
        _emailInputController.text,
        _passwordInputController.text,
      );
      if (loginResponse) {
        const snackBar =
            SnackBar(content: Text("Login Succesfull, redirecting..."));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DebugPage()),
        );
      }
    } catch (error) {
      log(" --- Login failed: $error --- ");
      final snackBar = SnackBar(content: Text("Login Failed: \n$error"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      )),
                  // make text unreadable on toggle and disable autocorrect and suggestions
                  obscureText: _passwordVisible,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        Authentication.logout();
                        Navigator.pop(context);
                      },
                      child: const Text("Logout"),
                    ),
                    ElevatedButton(
                      onPressed: submit,
                      child: const Text('Login'),
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
