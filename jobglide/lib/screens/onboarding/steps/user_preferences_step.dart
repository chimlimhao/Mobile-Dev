import 'package:flutter/material.dart';
import 'package:jobglide/models/model.dart';
import 'package:jobglide/screens/main/job_screen.dart';
import 'package:jobglide/services/auth_service.dart';
import 'package:jobglide/widgets/auto_apply_modal.dart';

class UserPreferencesStep extends StatefulWidget {
  final VoidCallback onNext;

  const UserPreferencesStep({
    super.key,
    required this.onNext,
  });

  @override
  State<UserPreferencesStep> createState() => _UserPreferencesStepState();
}

class _UserPreferencesStepState extends State<UserPreferencesStep> {
  final List<JobType> _selectedJobTypes = [JobType.fullTime];
  String _profession = 'Software Developer';
  bool _remoteOnly = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> _savePreferencesAndShowModal() async {
    if (!_formKey.currentState!.validate()) return;

    // Save user preferences
    final userPrefs = UserPreferences(
      profession: _profession,
      remoteOnly: _remoteOnly,
      preferredJobTypes: _selectedJobTypes,
    );
    await AuthService.updateUserPreferences(userPrefs);

    if (!mounted) return;

    // Show auto-apply modal
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AutoApplyModal(
        onChoice: (enableAutoApply) async {
          // Save auto-apply preference
          await AuthService.setAutoApplyEnabled(enableAutoApply);
          
          if (!mounted) return;
          
          // Navigate to main screen
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const JobScreen()),
            (route) => false,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Set Your Preferences',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            // Profession
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Profession',
                hintText: 'Enter your profession',
                border: OutlineInputBorder(),
              ),
              initialValue: _profession,
              onChanged: (value) => _profession = value,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your profession';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            
            // Job Types
            const Text(
              'Preferred Job Types',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: JobType.values.map((type) {
                final isSelected = _selectedJobTypes.contains(type);
                return FilterChip(
                  label: Text(type.toDisplayString()),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedJobTypes.add(type);
                      } else if (_selectedJobTypes.length > 1) {
                        _selectedJobTypes.remove(type);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            
            // Remote Only
            SwitchListTile(
              title: const Text('Remote Only'),
              value: _remoteOnly,
              onChanged: (value) {
                setState(() {
                  _remoteOnly = value;
                });
              },
            ),
            const SizedBox(height: 32),
            
            // Next Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _savePreferencesAndShowModal,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
