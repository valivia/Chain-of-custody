//import 'package:coc/components/button.dart';
import 'package:coc/pages/debug.dart';
import 'package:coc/service/location.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:coc/components/local_store.dart';
import 'package:coc/Themes/theme.dart';
import 'package:coc/components/case_list.dart';

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
    TextTheme aTextTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.home,)),
        centerTitle: true,
        title: Text('Home', style: aTextTheme.headlineMedium,),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings,)),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            //mainAxisSize: MainAxisSize.max,
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 20), // Add spacing between buttons

    	        SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  label: Text('Create Case', style: aTextTheme.bodyMedium,),
                  icon: const Icon(Icons.open_in_new),
                  iconAlignment: IconAlignment.end,
                  onPressed: () {},
                ),
              ),

              const SizedBox(height: 20), // Add spacing between buttons
              // const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  label: Text('Join case', style: aTextTheme.bodyMedium,),
                  icon: const Icon(Icons.photo_camera),
                  iconAlignment: IconAlignment.end,
                  onPressed: () {},
                ),
              ),

              const SizedBox(height: 20), // Add spacing between buttons
              // const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  label: Text('Transfer evidence', style: aTextTheme.bodyMedium,),
                  icon: const Icon(Icons.photo_camera),
                  iconAlignment: IconAlignment.end,
                  onPressed: () {},
                ),
              ),

              // const Spacer(),
              const SizedBox(height: 20), // Add spacing between buttons

              if (kDebugMode)
                // Debug page Button
                const SizedBox(height: 20), // Add spacing between buttons
                ElevatedButton(
                child: Text('Debug page', style: aTextTheme.bodyMedium,),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DebugPage()),
                  );
                },
              
              ),
              CaseList(),
            ],
          ),
          
        ),
        
      ),
    );
  }
}
