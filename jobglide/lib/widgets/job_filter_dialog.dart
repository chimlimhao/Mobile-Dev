import 'package:flutter/material.dart';
import 'package:jobglide/models/model.dart';

class JobFilter {
  final List<JobType> jobTypes;
  final bool remoteOnly;
  final String? searchQuery;

  const JobFilter({
    this.jobTypes = const [],
    this.remoteOnly = false,
    this.searchQuery,
  });

  JobFilter copyWith({
    List<JobType>? jobTypes,
    bool? remoteOnly,
    String? searchQuery,
  }) {
    return JobFilter(
      jobTypes: jobTypes ?? this.jobTypes,
      remoteOnly: remoteOnly ?? this.remoteOnly,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class JobFilterDialog extends StatefulWidget {
  final JobFilter initialFilter;

  const JobFilterDialog({
    super.key,
    required this.initialFilter,
  });

  @override
  State<JobFilterDialog> createState() => _JobFilterDialogState();
}

class _JobFilterDialogState extends State<JobFilterDialog> {
  late JobFilter _filter;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter;
    _searchController.text = _filter.searchQuery ?? '';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Jobs',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                hintText: 'Enter keywords',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _filter = _filter.copyWith(searchQuery: value);
                });
              },
            ),
            const SizedBox(height: 16),
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
                  selected: _filter.jobTypes.contains(type),
                  onSelected: (selected) {
                    setState(() {
                      final jobTypes = List<JobType>.from(_filter.jobTypes);
                      if (selected) {
                        jobTypes.add(type);
                      } else {
                        jobTypes.remove(type);
                      }
                      _filter = _filter.copyWith(jobTypes: jobTypes);
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Remote Only'),
              value: _filter.remoteOnly,
              onChanged: (value) {
                setState(() {
                  _filter = _filter.copyWith(remoteOnly: value);
                });
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context, const JobFilter());
                    },
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, _filter);
                    },
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
