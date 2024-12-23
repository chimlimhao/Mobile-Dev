import 'package:flutter/material.dart';
import '../models/student_score.dart';

class ScoreForm extends StatefulWidget {
  final Function(StudentScore) onScoreAdded;

  const ScoreForm({super.key, required this.onScoreAdded});

  @override
  State<ScoreForm> createState() => _ScoreFormState();
}

class _ScoreFormState extends State<ScoreForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _scoreController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newScore = StudentScore(
        name: _nameController.text,
        score: double.parse(_scoreController.text),
      );
      widget.onScoreAdded(newScore);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _scoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Add Score')),
        body: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Student Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _scoreController,
                  decoration: const InputDecoration(labelText: 'Score'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a score';
                    }
                    final score = double.tryParse(value);
                    if (score == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Add Score'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ));
  }
}
