import 'package:flutter/material.dart';
import 'package:jobglide/models/model.dart';
import 'package:jobglide/widgets/job_chip.dart';

class JobCard extends StatelessWidget {
  final Job job;
  final int index;

  const JobCard({
    super.key,
    required this.job,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Color(0xFFF0F5F0),  // Light mint color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job.title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Text(
              job.company,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: Colors.black54,
                ),
                const SizedBox(width: 4),
                Text(
                  job.location,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 12,
                children: [
                  JobChip(
                    label: job.isRemote ? 'Remote' : 'On-site',
                    bgColor: const Color(0xFFE3F2FD),
                    textColor: Colors.blue.shade700,
                  ),
                  JobChip(
                    label: job.jobType.toDisplayString(),
                    bgColor: const Color(0xFFE8F5E9),
                    textColor: Colors.green.shade700,
                  ),
                  JobChip(
                    label: job.profession,
                    bgColor: const Color(0xFFF3E5F5),
                    textColor: Colors.purple.shade700,
                  ),
                  JobChip(
                    label: job.salary,
                    bgColor: const Color(0xFFFFF8E1),
                    textColor: Colors.amber.shade800,
                    isWide: true,
                  ),
                ],
              ),
            ),
            // Back button at bottom
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back,
                  size: 20,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
