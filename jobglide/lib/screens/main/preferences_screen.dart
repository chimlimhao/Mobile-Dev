import 'package:flutter/material.dart';
import 'package:jobglide/models/model.dart';
import 'package:jobglide/services/auth_service.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _professionController = TextEditingController();
  bool _remoteOnly = false;
  final List<JobType> _selectedJobTypes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final user = AuthService.getCurrentUser();
    if (user != null) {
      setState(() {
        _professionController.text = user.preferences.profession;
        _remoteOnly = user.preferences.remoteOnly;
        _selectedJobTypes.clear();
        _selectedJobTypes.addAll(user.preferences.preferredJobTypes);
        _isLoading = false;
      });
    }
  }

  Future<void> _savePreferences() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final preferences = UserPreferences(
        profession: _professionController.text,
        remoteOnly: _remoteOnly,
        preferredJobTypes: _selectedJobTypes,
      );

      await AuthService.updateUserPreferences(preferences);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preferences saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save preferences'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _professionController,
              decoration: const InputDecoration(
                labelText: 'Profession',
                hintText: 'e.g. Mobile Developer',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your profession';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Job Types',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: JobType.values.map((type) {
                return FilterChip(
                  label: Text(type.toDisplayString()),
                  selected: _selectedJobTypes.contains(type),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedJobTypes.add(type);
                      } else {
                        _selectedJobTypes.remove(type);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              title: const Text('Remote Only'),
              subtitle: const Text('Only show remote jobs'),
              value: _remoteOnly,
              onChanged: (value) {
                setState(() {
                  _remoteOnly = value;
                });
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading ? null : _savePreferences,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save Preferences'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _professionController.dispose();
    super.dispose();
  }
}
