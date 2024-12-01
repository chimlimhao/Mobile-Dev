import 'package:flutter/material.dart';
import 'buttonStart.dart';
import 'package:app/quiz_app.dart';

class WelcomeScreen extends StatelessWidget {
  final Function(Pages) onStart;
  final String title;
  const WelcomeScreen({super.key, required this.title, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 200,
                child: Image.asset(
                  'assets/images/quiz-logo.png',
                  fit: BoxFit.cover,
                )),
            const SizedBox(
              height: 32,
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Roboto',
                fontSize: 32,
                fontWeight: FontWeight.w500,
              ),
            ),
            Buttonstart(trigger: onStart),
          ],
        ),
      ),
    );
  }
}
