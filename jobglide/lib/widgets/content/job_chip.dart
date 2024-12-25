import 'package:flutter/material.dart';

class JobChip extends StatelessWidget {
  final String label;
  final Color? bgColor;
  final Color? textColor;
  final bool isWide;

  const JobChip({
    super.key,
    required this.label,
    this.bgColor,
    this.textColor,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 16 : 12,
        vertical: isWide ? 8 : 6,
      ),
      decoration: BoxDecoration(
        color: bgColor ?? Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(isWide ? 20 : 16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor ?? Theme.of(context).colorScheme.onPrimaryContainer,
          fontSize: isWide ? 16 : 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
