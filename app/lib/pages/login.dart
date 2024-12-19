import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:coc/service/authentication.dart';
import 'package:coc/pages/debug.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

void setup(){
  getIt.registerSingleton<Authentication>(Authentication());
}

class _LoginPageState extends State<LoginPage> {
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
  void dispose(){
    _emailInputController.dispose();
    _passwordInputController.dispose();
    super.dispose();
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordInputController,
                  decoration: const InputDecoration(
                    labelText: "password", 
                    hintText: "Enter your password",
                    ),
                  // make text unreadable and disable autocorrect and suggestions
                  obscureText: true,
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
                        if (_formKey.currentState!.validate()) {
                          log(" --- Form Validation Succesfull ---");
                          try{
                            bool loginResponse = await Authentication.login(
                              _emailInputController.text,
                              _passwordInputController.text,
                            );
                            log("--- $loginResponse ---");
                            if(loginResponse){
                              log(" --- Logged in & token stored ---");
                              final snackBar = SnackBar(content: Text("Login Succesfull, redirecting..."));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DebugPage()
                                  ),
                                );                          
                              }
                          } catch (error){
                            log(" --- Login failed: $error --- ");
                            final snackBar = SnackBar(content: Text("Login Failed: \n$error"));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }                          
                        }
                        else{
                          log(" --- Form validation failed --- ");
                          final snackBar = SnackBar(content: Text('Please fill in all fields'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: const Text('Login'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Authentication.logout();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DebugPage()),
                          );
                      },
                      child: const Text("Logout"),
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