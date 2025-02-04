import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:coc/pages/login.dart';
import 'package:coc/service/authentication.dart';
import 'package:coc/service/settings.dart';

class SettingsPage extends WatchingStatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  bool isOffline = false; // TODO: Replace with actual value

  @override
  Widget build(BuildContext context) {
    final themeMode = watchPropertyValue((SettingManager a) => a.theme);
    TextTheme aTextTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Settings',
          style: aTextTheme.headlineLarge,
        ),
      ),
      body: ListView(
        children: <Widget>[
          // Name
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(di<Authentication>().user.fullName),
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
            title: Text(
              'Offline mode',
              style: aTextTheme.displaySmall,
            ),
            value: isOffline,
            onChanged: (bool value) {
              setState(() {
                isOffline = value;
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(
              'Logout',
              style: aTextTheme.displaySmall,
            ),
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
