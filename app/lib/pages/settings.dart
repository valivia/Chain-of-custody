// Login 
// Logout
// Togle light/darkmode?
// Offlinemode

import 'package:coc/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:coc/service/authentication.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Authentication.logout();
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  const LoginPage()),
                );
            },
          ),
          SwitchListTile(
            title: const Text('Toggle light/dark mode'),
            value: false, // Replace with actual value
            onChanged: (bool value) {
              // Handle theme change
            },
          ),
          SwitchListTile(
            title: const Text('Offline mode'),
            value: false, // Replace with actual value
            onChanged: (bool value) {
              // Handle offline mode change
            },
          ),
        ],
      ),
    );
  }
}