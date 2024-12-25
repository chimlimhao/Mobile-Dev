import 'package:flutter/material.dart';
import 'package:jobglide/models/model.dart';

class JobFilterDialog extends StatefulWidget {
  final JobFilter initialFilter;
  final Function(JobFilter) onApply;

  const JobFilterDialog({
    super.key,
    required this.initialFilter,
    required this.onApply,
  });

  @override
  State<JobFilterDialog> createState() => _JobFilterDialogState();
}

class _JobFilterDialogState extends State<JobFilterDialog> {
  late JobFilter _filter;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter;
    _locationController = TextEditingController(text: _filter.location);
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
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
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Location
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                prefixIcon: const Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _filter = _filter.copyWith(location: value);
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Remote only toggle
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  setState(() {
                    _filter = _filter.copyWith(
                      remoteOnly: !(_filter.remoteOnly ?? false),
                    );
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.laptop_mac_outlined),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Remote Only',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Switch(
                        value: _filter.remoteOnly ?? false,
                        onChanged: (value) {
                          setState(() {
                            _filter = _filter.copyWith(remoteOnly: value);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Job Types
            const Text(
              'Job Types',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: JobType.values.map((type) {
                final isSelected =
                    _filter.jobTypes?.contains(type) ?? false;
                return FilterChip(
                  label: Text(type.name),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      final currentTypes = _filter.jobTypes?.toList() ?? [];
                      if (selected) {
                        currentTypes.add(type);
                      } else {
                        currentTypes.remove(type);
                      }
                      _filter = _filter.copyWith(jobTypes: currentTypes);
                    });
                  },
                  backgroundColor: Colors.grey.shade100,
                  selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  checkmarkColor: Theme.of(context).colorScheme.primary,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade800,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Apply button
            ElevatedButton(
              onPressed: () {
                widget.onApply(_filter);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Apply Filters'),
            ),
          ],
        ),
      ),
    );
  }
}
