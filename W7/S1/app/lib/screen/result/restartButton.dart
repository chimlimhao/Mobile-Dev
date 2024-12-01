import 'package:flutter/material.dart';

class Restartbutton extends StatelessWidget {
  final VoidCallback trigger;
  const Restartbutton({super.key, required this.trigger});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: trigger,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(22),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        height: 44,
        width: 120,
        child: const Center(
            child: Text(
          "Restart",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        )),
      ),
    );
  }
}
