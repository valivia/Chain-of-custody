// Login
// Logout
// Togle light/darkmode?
// Offlinemode

// Flutter imports:
// import 'package:coc/Themes/theme.dart';
import 'package:coc/Themes/theme_manager.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:watch_it/watch_it.dart';

// Project imports:
import 'package:coc/pages/login.dart';
import 'package:coc/service/authentication.dart';

class SettingsPage extends WatchingWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = watchPropertyValue((SettingManager a) => a.theme);

    TextTheme aTextTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Settings', style: aTextTheme.headlineLarge,),
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
            value: themeMode == ThemeMode.dark,
            onChanged: (bool mode) {
              di<SettingManager>()
                  .setTheme(mode ? ThemeMode.dark : ThemeMode.light);
            },
          ),
          SwitchListTile(
            title: const Text('Offline mode'),
            value: false, // TODO: Replace with actual value
            onChanged: (bool value) {
              // TODO: Handle offline mode change
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
