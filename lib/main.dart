import 'package:flutter/material.dart';
import 'screens/first_screen.dart';

void main() {
  runApp(const MyApp());
}
var colorScheme = ColorScheme.fromSeed(seedColor: const Color.fromARGB(
    255, 22, 78, 101));
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData().copyWith(
        appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: colorScheme.onPrimaryContainer,
            iconTheme: const IconThemeData(color: Colors.white)
        ),

        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color.fromARGB(255, 50, 58, 60),
      ),
      home: const ShopFirstScreen(),
    );
  }
}
