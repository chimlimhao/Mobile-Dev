import 'package:flutter/material.dart';

class SnackbarUtils {
  static void showSnackBar(
    BuildContext context, {
    required String message,
    bool isSuccess = true,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );
  }
}
