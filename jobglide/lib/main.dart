import 'package:flutter/material.dart';
import 'package:jobglide/screens/auth/login_screen.dart';
import 'package:jobglide/screens/main/job_screen.dart';
import 'package:jobglide/screens/main/preferences_screen.dart';
import 'package:jobglide/screens/splash_screen.dart';
import 'package:jobglide/services/storage_service.dart';
import 'package:jobglide/services/auth_service.dart';
import 'package:jobglide/services/application_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  final storage = StorageService();
  await storage.init();
  await AuthService.init();
  await ApplicationService.init();  // Initialize ApplicationService
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JobGlide',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B82F6),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const JobScreen(),
        '/preferences': (context) => const PreferencesScreen(),
      },
    );
  }
}
