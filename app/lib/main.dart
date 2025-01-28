// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:localstorage/localstorage.dart';
import 'package:watch_it/watch_it.dart';

// Project imports:
import 'package:coc/components/button.dart';
import 'package:coc/components/lists/case.dart';
import 'package:coc/components/local_store.dart';
import 'package:coc/pages/debug.dart';
import 'package:coc/pages/forms/register_case.dart';
import 'package:coc/pages/scan_any_tag.dart';
import 'package:coc/pages/settings.dart';
import 'package:coc/pages/transfer_evidence.dart';
import 'package:coc/service/authentication.dart';
import 'package:coc/service/data.dart';
import 'package:coc/service/location.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalStore.init();
  await initLocalStorage();

  di.registerSingleton<Authentication>(await Authentication.create());

  di.registerSingleton<LocationService>(LocationService());

  di.registerSingleton<DataService>(await DataService.initialize());

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Color definition
    const Color primaryColor = Color.fromRGBO(23, 23, 23, 1);
    const Color secondaryColor = Color.fromRGBO(35, 35, 35, 1);
    const Color tertiaryColor = Color.fromRGBO(45, 45, 45, 1);
    const Color textColor = Color.fromRGBO(255, 255, 255, 1);

    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,

          error: Colors.red,
          onError: Colors.white,

          surface: tertiaryColor,
          onSurface: textColor,
          // primary,
          primary: primaryColor,
          onPrimary: textColor,
          primaryContainer: tertiaryColor,
          onPrimaryContainer: textColor,
          // secondary
          secondary: secondaryColor,
          onSecondary: textColor,
          secondaryContainer: secondaryColor,
          onSecondaryContainer: textColor,
          // tertiary
          tertiary: tertiaryColor,
          onTertiary: textColor,
          tertiaryContainer: primaryColor,
          onTertiaryContainer: textColor,
        ),
        appBarTheme: const AppBarTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
          backgroundColor: primaryColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(23, 23, 23, 1),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Color.fromRGBO(23, 23, 23, 1),
          contentTextStyle: TextStyle(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

// TODO:
// auth check
// Get token  -> if no token
//            -> check connection
// -> if no connection continue
//            -> login page
//          -> else -> continue

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(45, 45, 45, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(23, 23, 23, 1),
        leading: const Icon(Icons.home, color: Colors.white),
        title: const Text('Home'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
              icon: const Icon(Icons.settings)),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            children: [
              // Create Case Button
              const SizedBox(height: 20),
              Button(
                title: 'Create Case',
                icon: Icons.open_in_new,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterCase(),
                    ),
                  );
                },
              ),

              // Join Case Button
              const SizedBox(height: 20),
              Button(
                title: 'Join case',
                icon: Icons.photo_camera,
                onTap: () {},
              ),

              // Transfer Evidence Button
              const SizedBox(height: 20),
              Button(
                title: 'Transfer evidence',
                icon: Icons.qr_code_scanner,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  ScanAnyTagPage(
                        onScan: navigateToEvidenceTransfer(),
                        title: "Transfer Evidence",
                        ),
                    ),
                  );
                },
              ),

              // Debug page Button
              const SizedBox(height: 20),
              if (kDebugMode)
                ElevatedButton(
                  child: const Text('Debug page'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DebugPage(),
                      ),
                    );
                  },
                ),

              // Caselist view
              const SizedBox(height: 20),
              const LimCaseList(itemCount: 5),
            ],
          ),
        ),
      ),
    );
  }
}
