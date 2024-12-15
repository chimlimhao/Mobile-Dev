import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:jobglide/models/model.dart';
import 'package:jobglide/services/preferences_service.dart';
import 'package:jobglide/screens/main/job_screen.dart';

class JobCard extends StatelessWidget {
  final Job job;
  final bool isTop;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;
  final CardSwiperController swiperController;

  const JobCard({
    required this.job,
    required this.isTop,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    required this.swiperController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: isTop ? 8 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width - 32,
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF3B82F6),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              job.company,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(
                  job.location,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            const Spacer(),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: job.requirements.map((req) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    req,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FloatingActionButton(
                    heroTag: 'skip_button_${job.id}_${isTop ? 'top' : 'stack'}',
                    onPressed: () {
                      swiperController.swipe(CardSwiperDirection.left);
                    },
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.close, color: Colors.red),
                  ),
                  FloatingActionButton(
                    heroTag: 'apply_button_${job.id}_${isTop ? 'top' : 'stack'}',
                    onPressed: () {
                      swiperController.swipe(CardSwiperDirection.right);
                    },
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.check, color: Colors.green),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showApplyConfirmation(BuildContext context) async {
    bool? dontShowAgain = false;
    return showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Apply to this job?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Are you sure you want to apply to ${job.title} at ${job.company}?'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: dontShowAgain,
                    onChanged: (value) {
                      setState(() {
                        dontShowAgain = value;
                      });
                    },
                  ),
                  const Text("Don't show this again"),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (dontShowAgain == true) {
                  await PreferencesService.setShowApplyConfirmation(false);
                }
                Navigator.of(context).pop(true);
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }
}
