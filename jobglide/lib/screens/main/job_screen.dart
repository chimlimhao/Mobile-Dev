import 'package:flutter/material.dart';
import 'package:jobglide/models/model.dart';
import 'package:jobglide/widgets/job_card.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:jobglide/data/dummy_data.dart';
import 'package:jobglide/services/preferences_service.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JobGlide'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          JobListView(),
          Center(child: Text('Applications')),
          Center(child: Text('Profile')),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            activeIcon: Icon(Icons.star),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            activeIcon: Icon(Icons.work),
            label: 'Applications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class JobListView extends StatefulWidget {
  const JobListView({super.key});

  @override
  State<JobListView> createState() => _JobListViewState();
}

class _JobListViewState extends State<JobListView> {
  late List<Job> _jobs;
  final CardSwiperController _swiperController = CardSwiperController();

  @override
  void initState() {
    super.initState();
    // Filter jobs based on user preferences
    _jobs = dummyJobs.where((job) {
      return job.profession == userPreferences.profession ||
          job.experienceLevel == userPreferences.experienceLevel ||
          userPreferences.preferredJobTypes.contains(job.jobType) ||
          (userPreferences.remoteOnly ? job.isRemote : true);
    }).toList();
  }

  void _handleSwipeLeft() {
    // Do nothing on reject
  }

  void _handleSwipeRight(Job job) {
    // Add to applied jobs
    dummyUsers[0].appliedJobs.add(job.id);
  }

  @override
  Widget build(BuildContext context) {
    if (_jobs.isEmpty) {
      return const Center(
        child: Text('No more jobs available'),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CardSwiper(
                cardBuilder: (context, index, horizontalThresholdPercentage,
                    verticalThresholdPercentage) {
                  return JobCard(
                    job: _jobs[index],
                    isTop: index == 0,
                    onSwipeLeft: _handleSwipeLeft,
                    onSwipeRight: () => _handleSwipeRight(_jobs[index]),
                  );
                },
                controller: _swiperController,
                cardsCount: _jobs.length,
                onSwipe: (previousIndex, currentIndex, direction) async {
                  if (direction == CardSwiperDirection.right) {
                    bool shouldShow =
                        await PreferencesService.shouldShowApplyConfirmation();
                    if (shouldShow) {
                      bool? confirmed =
                          await _showApplyConfirmation(_jobs[previousIndex]);
                      if (confirmed == true) {
                        _handleSwipeRight(_jobs[previousIndex]);
                      }
                    } else {
                      _handleSwipeRight(_jobs[previousIndex]);
                    }
                  } else if (direction == CardSwiperDirection.left) {
                    _handleSwipeLeft();
                  }
                  return true;
                },
                numberOfCardsDisplayed: 3,
                backCardOffset: const Offset(0, 0),
                padding: EdgeInsets.zero,
                isDisabled: false,
                allowedSwipeDirection:
                    AllowedSwipeDirection.only(left: true, right: true),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    onPressed: () =>
                        _swiperController.swipe(CardSwiperDirection.left),
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.close, color: Colors.red),
                  ),
                  FloatingActionButton(
                    onPressed: () =>
                        _swiperController.swipe(CardSwiperDirection.right),
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

  Future<bool?> _showApplyConfirmation(Job job) async {
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

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }
}
