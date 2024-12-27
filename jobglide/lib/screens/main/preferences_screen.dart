import 'package:flutter/material.dart';
import 'package:jobglide/models/models.dart';
import 'package:jobglide/services/auth_service.dart';
import 'package:jobglide/data/dummy_data.dart';
import 'package:jobglide/utils/snackbar_utils.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  late TextEditingController _searchController;
  late bool _remoteOnly;
  late List<JobType> _selectedJobTypes;
  List<String> _suggestions = [];
  bool _showSuggestions = false;
  Set<String> _selectedProfessions = {};

  // Get unique professions from dummy data
  List<String> get _availableProfessions {
    return dummyJobs.map((job) => job.profession).toSet().toList()..sort();
  }

  @override
  void initState() {
    super.initState();
    final user = AuthService.getCurrentUser();
    _searchController = TextEditingController();
    _remoteOnly = user.preferences.remoteOnly;
    _selectedJobTypes = List.from(user.preferences.preferredJobTypes);
    _selectedProfessions = Set.from(user.preferences.professions);

    // Add listener for search field changes
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    setState(() {
      _suggestions = _availableProfessions
          .where((profession) => profession.toLowerCase().contains(query))
          .where((profession) => !_selectedProfessions.contains(profession))
          .toList();
      _showSuggestions = true;
    });
  }

  void _selectProfession(String profession) {
    setState(() {
      _selectedProfessions.add(profession);
      _searchController.clear();
      _showSuggestions = false;
    });
  }

  void _removeProfession(String profession) {
    setState(() {
      _selectedProfessions.remove(profession);
    });
  }

  void _savePreferences() {
    final preferences = UserPreferences(
      professions: _selectedProfessions.toList(),
      remoteOnly: _remoteOnly,
      preferredJobTypes: _selectedJobTypes,
    );

    AuthService.updateUserPreferences(preferences);

    SnackbarUtils.showSnackBar(
      context,
      message: 'Preferences saved successfully!',
      isSuccess: true,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.grey),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search professions...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _showSuggestions = false;
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF6750A4),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: const Text('Clear'),
                  ),
              ],
            ),
          ),
          if (_selectedProfessions.isNotEmpty)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedProfessions.map((profession) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8DEF8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          profession,
                          style: const TextStyle(
                            color: Color(0xFF6750A4),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: () => _removeProfession(profession),
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: Color(0xFF6750A4),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          if (_selectedProfessions.isNotEmpty)
            const Divider(height: 1, thickness: 1),
          Expanded(
            child: _showSuggestions && _suggestions.isNotEmpty
                ? _buildSuggestionsList()
                : _buildPreferencesContent(),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: TextButton(
                onPressed: _savePreferences,
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF6750A4),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'DONE',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsList() {
    return ListView.builder(
      itemCount: _suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = _suggestions[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Text(suggestion),
          onTap: () => _selectProfession(suggestion),
        );
      },
    );
  }

  Widget _buildPreferencesContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionTitle('Remote Options'),
        const SizedBox(height: 12),
        _buildOptionButton(
          label: 'Remote Only',
          isSelected: _remoteOnly,
          onTap: () => setState(() => _remoteOnly = !_remoteOnly),
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('Job Types'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: JobType.values.map((type) {
            return _buildOptionButton(
              label: type.toDisplayString(),
              isSelected: _selectedJobTypes.contains(type),
              onTap: () => setState(() {
                if (_selectedJobTypes.contains(type)) {
                  _selectedJobTypes.remove(type);
                } else {
                  _selectedJobTypes.add(type);
                }
              }),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildOptionButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: isSelected ? const Color(0xFFE8DEF8) : Colors.grey.shade200,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF6750A4) : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
