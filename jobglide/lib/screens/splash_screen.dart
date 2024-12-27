import 'package:flutter/material.dart';
// import 'package:jobglide/screens/onboarding_screen.dart';
import 'package:jobglide/screens/main/job_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToOnboarding();
  }

  Future<void> _navigateToOnboarding() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const JobScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      body: Center(
        child: Text(
          'JobGlide',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF6750A4),
            letterSpacing: 1.2,
            shadows: [
              Shadow(
                color: Colors.blue.withOpacity(0.2),
                offset: const Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
