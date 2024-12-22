import 'package:flutter/material.dart';

class JobChip extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;
  final bool isWide;

  const JobChip({
    super.key,
    required this.label,
    required this.bgColor,
    required this.textColor,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 16 : 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: isWide ? 16 : 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
