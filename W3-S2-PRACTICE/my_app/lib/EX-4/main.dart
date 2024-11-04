// Start from the exercice 3 code
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Container(
      color: Colors.grey[300],
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomCard(text: "OOP", color: Colors.blue[100]),
          const SizedBox(height: 20),
          CustomCard(text: "DART", color: Colors.blue[300]),
          const SizedBox(height: 20),
          CustomCard.gradient(
            text: "FLUTTER",
            colors: [Colors.blue[300]!, Colors.blue[600]!],
          ),
        ],
      ),
    ),
  ));
}

class CustomCard extends StatelessWidget {
  final String text;
  final Color? color;
  final List<Color>? colors;
  const CustomCard({
    super.key,
    required this.text,
    this.color = Colors.blue,
  }) : colors = null;

  const CustomCard.gradient({
    super.key,
    required this.text,
    required this.colors,
  }) : color = null;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildGradient(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors!,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
