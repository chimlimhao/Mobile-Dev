import 'package:flutter/material.dart';

class NameStep extends StatefulWidget {
  final VoidCallback? onNext;

  const NameStep({this.onNext, super.key});

  @override
  State<NameStep> createState() => _NameStepState();
}

class _NameStepState extends State<NameStep> {
  final _nameController = TextEditingController();
  bool _canContinue = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateInput);
  }

  void _validateInput() {
    setState(() {
      _canContinue = _nameController.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What is your full\nname?',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Enter your full name',
              border: UnderlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your full name will be stored in the application',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _canContinue ? widget.onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Next →',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.removeListener(_validateInput);
    _nameController.dispose();
    super.dispose();
  }
}
