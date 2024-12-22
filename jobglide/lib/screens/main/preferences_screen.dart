import 'package:flutter/material.dart';
import 'package:jobglide/models/model.dart';
import 'package:jobglide/services/auth_service.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  late TextEditingController _professionController;
  late bool _remoteOnly;
  late List<JobType> _selectedJobTypes;

  @override
  void initState() {
    super.initState();
    final user = AuthService.getCurrentUser();
    _professionController = TextEditingController(text: user.preferences.profession);
    _remoteOnly = user.preferences.remoteOnly;
    _selectedJobTypes = List.from(user.preferences.preferredJobTypes);
  }

  @override
  void dispose() {
    _professionController.dispose();
    super.dispose();
  }

  void _savePreferences() {
    final preferences = UserPreferences(
      profession: _professionController.text.trim(),
      remoteOnly: _remoteOnly,
      preferredJobTypes: _selectedJobTypes,
    );
    
    AuthService.updateUserPreferences(preferences);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preferences saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profession Input
          TextField(
            controller: _professionController,
            decoration: const InputDecoration(
              labelText: 'Profession',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.work),
            ),
          ),
          const SizedBox(height: 24),

          // Remote Only Switch
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.home_work, color: Colors.grey),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Remote Only',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Switch(
                  value: _remoteOnly,
                  onChanged: (value) => setState(() => _remoteOnly = value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Job Types
          const Text(
            'Preferred Job Types',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: JobType.values.map((type) {
              final isSelected = _selectedJobTypes.contains(type);
              return FilterChip(
                label: Text(type.toString().split('.').last),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedJobTypes.add(type);
                    } else {
                      _selectedJobTypes.remove(type);
                    }
                  });
                },
                backgroundColor: Colors.grey.shade200,
                selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                checkmarkColor: Theme.of(context).colorScheme.primary,
                labelStyle: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.black87,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),

          // Save Button
          ElevatedButton.icon(
            onPressed: _savePreferences,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.save),
            label: const Text(
              'Save Preferences',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
