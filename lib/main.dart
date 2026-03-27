import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stac/stac.dart';
import 'screens/sdui_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Stac.initialize(); // no Stac Cloud needed — we're rendering manually
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SDUI Research',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // 1. Remove 'home' and set the initial route
      initialRoute: '/',
      // 2. Define the routes and pass the specific Bin IDs
      routes: {
        '/': (context) => const SduiScreen(
          // Replace with the Bin ID for your Home Screen JSON
          binId: '69c3d6c7aa77b81da91a4b3b',
        ),
        '/profile_screen': (context) => const SduiScreen(
          // Replace with the Bin ID for your Profile Screen JSON
          binId: '69c532e3aa77b81da9206c13',
        ),
      },
    );
  }
}
