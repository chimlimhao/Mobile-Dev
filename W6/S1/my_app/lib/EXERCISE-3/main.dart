import 'package:flutter/material.dart';
import 'package:my_app/EXERCISE-3/screen/welcome.dart';
import 'package:my_app/EXERCISE-3/screen/temperature.dart';

enum Screen { welcome, temperature }

class TemperatureApp extends StatefulWidget {
  const TemperatureApp({super.key});

  @override
  State<TemperatureApp> createState() {
    return _TemperatureAppState();
  }
}

class _TemperatureAppState extends State<TemperatureApp> {
  Screen currentScreen = Screen.welcome;

  void switchScreen() {
    setState(() {
      currentScreen = Screen.temperature;
    });
  }

  @override
  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff16C062),
                Color(0xff00BCDC),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: currentScreen == Screen.welcome
              ? Welcome(onStartPressed: switchScreen)
              : Temperature(),
        ),
      ),
    );
  }
}

void main() {
  runApp(const TemperatureApp());
}
