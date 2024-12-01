import 'package:flutter/material.dart';
import 'package:app/quiz_app.dart';

class Buttonstart extends StatelessWidget {
  final Function(Pages) trigger;
  const Buttonstart({super.key, required this.trigger});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => trigger(Pages.started),
      child: Container(
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
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Start",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(
                width: 8,
              ),
              Icon(
                Icons.arrow_forward,
                size: 16,
              )
            ],
          )),
    );
  }
}
