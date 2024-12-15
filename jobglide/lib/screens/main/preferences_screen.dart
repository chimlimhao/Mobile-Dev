import 'package:flutter/material.dart';
import '../../models/model.dart';
import '../../services/auth_service.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  late UserPreferences _preferences;
  final List<JobType> _selectedJobTypes = [];
  bool _isRemoteOnly = false;
  ExperienceLevel? _selectedExperience;
  Profession? _selectedProfession;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() {
    final prefs = AuthService.getUserPreferences();
    if (prefs != null) {
      setState(() {
        _preferences = prefs;
        _selectedJobTypes.addAll(prefs.preferredJobTypes);
        _isRemoteOnly = prefs.remoteOnly;
        _selectedExperience = prefs.experienceLevel;
        _selectedProfession = prefs.profession;
      });
    }
  }

  void _savePreferences() {
    final newPrefs = UserPreferences(
      location: _preferences.location, // Keep existing location
      experienceLevel: _selectedExperience ?? _preferences.experienceLevel,
      profession: _selectedProfession ?? _preferences.profession,
      preferredJobTypes: _selectedJobTypes,
      remoteOnly: _isRemoteOnly,
      expectedSalary: _preferences.expectedSalary, // Keep existing salary
    );

    AuthService.updateUserPreferences(newPrefs);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preferences updated! New jobs loaded.'),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.pop(context, true); // Return true to indicate preferences were updated
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Preferences'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Profession',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<Profession>(
                    value: _selectedProfession,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    items: Profession.values.map((profession) {
                      return DropdownMenuItem(
                        value: profession,
                        child: Text(profession.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedProfession = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Experience Level',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<ExperienceLevel>(
                    value: _selectedExperience,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    items: ExperienceLevel.values.map((level) {
                      return DropdownMenuItem(
                        value: level,
                        child: Text(level.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedExperience = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Job Types',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
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
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Remote Only'),
            subtitle: const Text('Only show remote job opportunities'),
            value: _isRemoteOnly,
            onChanged: (value) {
              setState(() {
                _isRemoteOnly = value;
              });
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _savePreferences,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Save Preferences'),
          ),
        ],
      ),
    );
  }
}
