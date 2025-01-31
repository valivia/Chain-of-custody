//// Dart imports:
import 'dart:convert';

// Flutter imports:
// import 'package:coc/components/lists/case.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:localstorage/localstorage.dart';
import 'package:watch_it/watch_it.dart';

// Project imports:
import 'package:coc/components/button.dart';

import 'package:coc/components/local_store.dart';
import 'package:coc/controllers/user.dart';
import 'package:coc/pages/case_detail.dart';
import 'package:coc/pages/debug.dart';
import 'package:coc/pages/forms/register_case.dart';
import 'package:coc/pages/login.dart';
import 'package:coc/pages/scan_any_tag.dart';
import 'package:coc/pages/scannable.dart';
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

  di.registerSingletonAsync<Authentication>(Authentication.create);

  di.registerSingleton<LocationService>(LocationService());

  di.registerSingletonAsync<DataService>(
    DataService.initialize,
    dependsOn: [Authentication],
  );

  await di.allReady();

  di<DataService>().syncWithApi();

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

      home: const HomePage(),

       
      initialRoute: "/",
      routes: {
        "/": (context) => const HomePage(),
        "/case": (context) => const CaseDetailView(),
        "/settings": (context) => const SettingsPage(),
      },
    );
  }
}

class HomePage extends WatchingWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme aTextTheme = Theme.of(context).textTheme;
    final isLoggedIn = watchPropertyValue((Authentication a) => a.isLoggedIn);

    if (!isLoggedIn) {
      return const LoginPage();
    }

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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScannablePage(
                        data: jsonEncode(
                          UserScannable.fromUser(di<Authentication>().user)
                              .toJson(),
                        ),
                        title: "Join Case",
                        description:
                            "Let the manager of the case scan this QR code to join the case",
                        onDone: (context) {
                          Navigator.pop(context);
                          di<DataService>().syncWithApi();
                        },
                      ),
                    ),
                  );
                },
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
                      builder: (context) => ScanAnyTagPage(
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
              // const LimCaseList(itemCount: 5),
              
            ],
          ),
          
        ),
        
      ),
    );
  }
}
