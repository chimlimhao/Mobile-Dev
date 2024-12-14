import 'package:flutter/material.dart';
import 'package:jobglide/models/model.dart';
import 'package:jobglide/screens/main/job_screen.dart';

class UserPreferencesStep extends StatefulWidget {
  final VoidCallback? onNext;
  const UserPreferencesStep({this.onNext, super.key});

  @override
  State<UserPreferencesStep> createState() => _UserPreferencesStepState();
}

class _UserPreferencesStepState extends State<UserPreferencesStep> {
  Profession? _selectedProfession;
  ExperienceLevel? _selectedExperience;
  final List<JobType> _selectedJobTypes = [];
  bool _remoteOnly = false;
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();

  bool get _canContinue =>
      _selectedProfession != null ||
      _selectedExperience != null ||
      _selectedJobTypes.isNotEmpty ||
      _locationController.text.isNotEmpty ||
      _salaryController.text.isNotEmpty ||
      _remoteOnly;

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Almost there!\nTell us your preferences',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Profession Dropdown
                _buildSectionTitle('What is your profession?'),
                DropdownButtonFormField<Profession>(
                  value: _selectedProfession,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  hint: const Text('Select your profession'),
                  items: Profession.values.map((profession) {
                    return DropdownMenuItem(
                      value: profession,
                      child: Text(profession.toDisplayString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedProfession = value;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Experience Level Dropdown
                _buildSectionTitle('Experience Level'),
                DropdownButtonFormField<ExperienceLevel>(
                  value: _selectedExperience,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  hint: const Text('Select your experience level'),
                  items: ExperienceLevel.values.map((level) {
                    return DropdownMenuItem(
                      value: level,
                      child: Text(level.toDisplayString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedExperience = value;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Job Types Multi-Select
                _buildSectionTitle('Preferred Job Types'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: JobType.values.map((type) {
                    final isSelected = _selectedJobTypes.contains(type);
                    return FilterChip(
                      selected: isSelected,
                      label: Text(type.toDisplayString()),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedJobTypes.add(type);
                          } else {
                            _selectedJobTypes.remove(type);
                          }
                        });
                      },
                      selectedColor: Colors.blue.shade100,
                      checkmarkColor: Colors.blue,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Location Input
                _buildSectionTitle('Preferred Location'),
                TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your preferred location',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
                const SizedBox(height: 16),

                // Expected Salary
                _buildSectionTitle('Expected Salary'),
                TextField(
                  controller: _salaryController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter your expected salary',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
                const SizedBox(height: 16),

                // Remote Only Switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Remote Only',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Switch(
                      value: _remoteOnly,
                      onChanged: (value) {
                        setState(() {
                          _remoteOnly = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canContinue
                    ? () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const JobScreen(),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Finish',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _locationController.dispose();
    _salaryController.dispose();
    super.dispose();
  }
}
