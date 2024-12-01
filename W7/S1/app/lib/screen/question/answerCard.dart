import 'package:flutter/material.dart';

class Answercard extends StatelessWidget {
  final String possibleAnswer;
  final Function(String) trigger;
  const Answercard(
      {super.key, required this.possibleAnswer, required this.trigger});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: InkWell(
      onTap: () => trigger(possibleAnswer),
      child: Card(
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
        child: ListTile(
          leading: Text(
            possibleAnswer,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ),
      ),
    ));
  }
}
