// Login
// Logout
// Togle light/darkmode?
// Offlinemode

// Flutter imports:
// import 'package:coc/Themes/theme.dart';
import 'package:coc/Themes/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Package imports:
import 'package:watch_it/watch_it.dart';

// Project imports:
import 'package:coc/pages/login.dart';
import 'package:coc/service/authentication.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          // Name
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(
                "${di<Authentication>().user.firstName} ${di<Authentication>().user.lastName}"),
          ),
          // Email
          ListTile(
            leading: const Icon(Icons.email),
            title: Text(di<Authentication>().user.email),
          ),
          SwitchListTile(
            title: const Text('Toggle light/dark mode'),
            value: themeManager.themeMode == ThemeMode.dark, // Replace with actual value
            onChanged: (bool newValue) {
              themeManager.toggleTheme(newValue);
            },
          ),
          SwitchListTile(
            title: const Text('Offline mode'),
            value: false, // Replace with actual value
            onChanged: (bool value) {
              // Handle offline mode change
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              di<Authentication>().logout();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }
}
