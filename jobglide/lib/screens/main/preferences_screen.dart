import 'package:flutter/material.dart';
import 'package:jobglide/models/model.dart';
import 'package:jobglide/services/auth_service.dart';
import 'package:jobglide/data/dummy_data.dart';

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
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preferences saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
        backgroundColor: const Color(0xFF7A288A),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Section
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar Row
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search professions...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _showSuggestions = false;
                          });
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF7A288A),
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                  if (_selectedProfessions.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _selectedProfessions.map((profession) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(profession),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => _removeProfession(profession),
                                child: Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: _showSuggestions && _suggestions.isNotEmpty
                  ? ListView.builder(
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = _suggestions[index];
                        return ListTile(
                          title: Text(suggestion),
                          onTap: () => _selectProfession(suggestion),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                        );
                      },
                    )
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // Remote Options
                        const Text(
                          'Remote Options',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: _remoteOnly 
                              ? const Color(0xFFE8DEF8)  // Light purple for selected
                              : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _remoteOnly = !_remoteOnly;
                                });
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Text(
                                  'Remote Only',
                                  style: TextStyle(
                                    color: _remoteOnly 
                                      ? const Color(0xFF6750A4)  // Primary purple for selected
                                      : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Job Types
                        const Text(
                          'Job Types',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: JobType.values.map((type) {
                            final isSelected = _selectedJobTypes.contains(type);
                            return Container(
                              decoration: BoxDecoration(
                                color: isSelected 
                                  ? const Color(0xFFE8DEF8)  // Light purple for selected
                                  : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (isSelected) {
                                        _selectedJobTypes.remove(type);
                                      } else {
                                        _selectedJobTypes.add(type);
                                      }
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    child: Text(
                                      type.toDisplayString(),
                                      style: TextStyle(
                                        color: isSelected 
                                          ? const Color(0xFF6750A4)  // Primary purple for selected
                                          : Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
            ),

            // Done Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _savePreferences,
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF7A288A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
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
      ),
    );
  }
}
