import 'package:coc/components/button.dart';
import 'package:coc/pages/debug.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final globalState = GetIt.instance;

void main() {
  globalState.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}

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
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            spacing: 20,
            children: [
              // Create Case Button
              Button(
                title: 'Create Case',
                icon: Icons.open_in_new,
                onTap: () {},
              ),

              // Join Case Button
              Button(
                title: 'Join case',
                icon: Icons.photo_camera,
                onTap: () {},
              ),

              // Transfer Evidence Button
              Button(
                title: 'Transfer evidence',
                icon: Icons.photo_camera,
                onTap: () {},
              ),

              if (kDebugMode)
                // Debug page Button
                ElevatedButton(
                  child: const Text('Debug page'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DebugPage()),
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
