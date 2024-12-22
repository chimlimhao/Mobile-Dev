import 'package:flutter/material.dart';
import 'package:jobglide/screens/login_screen.dart';
import 'package:jobglide/screens/onboarding/onboarding_screen.dart';
import 'package:jobglide/services/storage_service.dart';
import 'package:jobglide/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeAndCheck();
  }

  Future<void> _initializeAndCheck() async {
    // Initialize services first
    final storage = StorageService();
    await storage.init();
    await AuthService.init();

    // Simulate loading
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    if (storage.isFirstTime()) {
      await storage.setFirstTime(false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    } else {
      // Check if user is already logged in
      if (AuthService.isLoggedIn()) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo
            const Text(
              'JobGlide',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3B82F6),
              ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
