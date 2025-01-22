//// Flutter imports:
import 'package:coc/components/lists/case.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:localstorage/localstorage.dart';
import 'package:watch_it/watch_it.dart';

// Project imports:
import 'package:coc/components/button.dart';

import 'package:coc/components/local_store.dart';
import 'package:coc/pages/debug.dart';
import 'package:coc/pages/forms/register_case.dart';
import 'package:coc/pages/scanner.dart';
import 'package:coc/pages/settings.dart';
import 'package:coc/pages/transfer_evidence.dart';
import 'package:coc/service/authentication.dart';
import 'package:coc/service/data.dart';
import 'package:coc/service/location.dart';


import 'package:coc/Themes/theme.dart';

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
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      //     surface: tertiaryColor,
      //     onSurface: textColor,
      //     // primary,
      //     primary: primaryColor,
      //     onPrimary: textColor,
      //     primaryContainer: tertiaryColor,
      //     onPrimaryContainer: textColor,
      //     // secondary
      //     secondary: secondaryColor,
      //     onSecondary: textColor,
      //     secondaryContainer: secondaryColor,
      //     onSecondaryContainer: textColor,
      //     // tertiary
      //     tertiary: tertiaryColor,
      //     onTertiary: textColor,
      //     tertiaryContainer: primaryColor,
      //     onTertiaryContainer: textColor,
      //   ),
      // ),
      
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
    TextTheme aTextTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.home,)),
        centerTitle: true,
        title: Text('Home', style: aTextTheme.headlineLarge,),
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
            //mainAxisSize: MainAxisSize.max,
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                icon: Icons.photo_camera,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QRScannerPage(
                        onScan: navigateToEvidenceTransfer(),
                      ),
                    ),
                  );
                },
              ),

              // Debug page Button
              const SizedBox(height: 20),
              if (kDebugMode)
                ElevatedButton(
                child: Text('Debug page', style: aTextTheme.bodyMedium,),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DebugPage()),
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
