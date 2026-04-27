import 'package:flutter/material.dart';
import 'cores/constants/themes.dart';
import 'home_screen/home_screen.dart';

void main() {
  runApp(const NutrilensApp());
}

class NutrilensApp extends StatelessWidget {
  const NutrilensApp({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      // initialRoute: "Nutrients Tracker",
      debugShowCheckedModeBanner: false,
      darkTheme: AppTheme.darkTheme,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      // home: InitialScreen(),
      // home: InputScreen(),
      home: HomeScreen(),
    );
  }
}