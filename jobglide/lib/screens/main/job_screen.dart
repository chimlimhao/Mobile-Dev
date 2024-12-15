import 'package:flutter/material.dart';
import 'package:jobglide/models/model.dart';
import 'package:jobglide/screens/main/profile_screen.dart';
import 'package:jobglide/widgets/job_card.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:jobglide/data/dummy_data.dart';
import 'package:jobglide/services/preferences_service.dart';
import 'applications_screen.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  int _selectedIndex = 0;
  List<Job> appliedJobs = [];

  void updateAppliedJobs(Job job) {
    setState(() {
      appliedJobs.add(job);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          JobListView(onJobApplied: updateAppliedJobs),
          ApplicationsScreen(appliedJobs: appliedJobs),
          const ProfileScreen(),
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
  final Function(Job) onJobApplied;
  const JobListView({super.key, required this.onJobApplied});

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

  void onSwipeLeft() {
    // Check if there are any jobs to skip
    if (_jobs.isNotEmpty) {
      final job = _jobs.first; // Get the first job or handle accordingly
      print('Job skipped: ${job.title}');
      // Optionally, remove the job from the list if you want to update the UI
      setState(() {
        _jobs.removeAt(0); // Remove the job from the list
      });
    } else {
      print('No jobs to skip');
    }
  }

  void onSwipeRight(Job job) {
    // Add to applied jobs
    dummyUsers[0].appliedJobs.add(job.id);
    print('Job applied: ${_jobs.first.title}');
    widget.onJobApplied(job);
  }

  @override
  Widget build(BuildContext context) {
    if (_jobs.isEmpty) {
      return const Center(
        child: Text('No more jobs available'),
      );
    }

    return Scaffold(
        appBar: AppBar(
            title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, size: 20, color: Colors.amber[700]),
                    const SizedBox(width: 4),
                    const Text('5',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold))
                  ],
                )),
            const Text(
              'JobGlide',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.tune),
              onPressed: () {},
            )
          ],
        )),
        body: Container(
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
                        onSwipeLeft: onSwipeLeft,
                        onSwipeRight: () => onSwipeRight(_jobs[index]),
                        swiperController: _swiperController,
                      );
                    },
                    controller: _swiperController,
                    cardsCount: _jobs.length,
                    onSwipe: (previousIndex, currentIndex, direction) async {
                      if (direction == CardSwiperDirection.right) {
                        bool shouldShow = await PreferencesService
                            .shouldShowApplyConfirmation();
                        if (shouldShow) {
                          bool? confirmed = await _showApplyConfirmation(
                              _jobs[previousIndex]);
                          if (confirmed == true) {
                            onSwipeRight(_jobs[previousIndex]);
                          }
                        } else {
                          onSwipeRight(_jobs[previousIndex]);
                        }
                      } else if (direction == CardSwiperDirection.left) {
                        onSwipeLeft();
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
              ],
            ),
          ),
        ));
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
