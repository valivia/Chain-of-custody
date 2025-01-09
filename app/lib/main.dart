import 'package:coc/components/button.dart';
import 'package:coc/pages/debug.dart';
import 'package:coc/service/location.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:coc/components/local_store.dart';
import 'package:coc/Themes/theme.dart';

final globalState = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and open the box
  await LocalStore.init();

  globalState.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
  globalState.registerSingleton<LocationService>(LocationService());

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme AtextTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.home, color: Colors.white),
        title: const Text('Home', style: AtextTheme.headlineLarge), //TODO:: fix this
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 20), // Add spacing between buttons
              // Create Case Button
              Button(
                title: 'Create Case',
                icon: Icons.open_in_new,
                onTap: () {},
              ),

              const SizedBox(height: 20), // Add spacing between buttons
              // Join Case Button
              Button(
                title: 'Join case',
                icon: Icons.photo_camera,
                onTap: () {},
              ),

              const SizedBox(height: 20), // Add spacing between buttons
              // Transfer Evidence Button
              Button(
                title: 'Transfer evidence',
                icon: Icons.photo_camera,
                onTap: () {},
              ),

              if (kDebugMode)
                // Debug page Button
                const SizedBox(height: 20), // Add spacing between buttons
              ElevatedButton(
                child: const Text('Debug page'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DebugPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
