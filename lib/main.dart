import 'package:flutter/material.dart';
import 'package:stac/stac.dart';
import 'default_stac_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Stac.initialize(options: defaultStacOptions);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SDUI Research',
      home: const Stac(routeName: 'home_screen'),
    );
  }
}
