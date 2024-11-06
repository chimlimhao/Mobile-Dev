import 'package:flutter/material.dart';

class HobbyCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color backgroundColor;
  final Color color;

  const HobbyCard({
    required this.text,
    required this.icon,
    this.backgroundColor = Colors.blue,
    this.color = Colors.white,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 74,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.only(left: 30),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 20),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text("My Hobbies")),
      body: Container(
        color: Colors.grey,
        child: const Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HobbyCard(
                text: "Games",
                icon: Icons.gamepad_rounded,
                backgroundColor: Color(0xFF1A1C1F),
              ),
              SizedBox(height: 10),
              HobbyCard(
                text: "Music",
                icon: Icons.music_note_rounded,
                backgroundColor: Color(0xFF6A3091),
              ),
            ],
          ),
        ),
      ),
    ),
  ));
}
