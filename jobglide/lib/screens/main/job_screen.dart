import 'package:flutter/material.dart';
import 'package:jobglide/models/model.dart';
import 'package:jobglide/screens/main/profile_screen.dart';
import 'package:jobglide/widgets/job_card.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:jobglide/data/dummy_data.dart';
import 'package:jobglide/services/preferences_service.dart';
import 'package:jobglide/services/auth_service.dart';
import 'applications_screen.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  int _selectedIndex = 0;
  List<Job> appliedJobs = [];

  @override
  void initState() {
    super.initState();
    _loadAppliedJobs();
  }

  void _loadAppliedJobs() {
    final user = AuthService.getCurrentUser();
    if (user != null) {
      setState(() {
        appliedJobs = dummyJobs.where((job) => user.appliedJobs.contains(job.id)).toList();
      });
    }
  }

  void updateAppliedJobs(Job job) {
    if (!appliedJobs.any((j) => j.id == job.id)) {
      setState(() {
        appliedJobs.add(job);
      });
    }
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
  List<Job> _jobs = [];
  late final CardSwiperController _swiperController;

  @override
  void initState() {
    super.initState();
    _swiperController = CardSwiperController();
    _loadJobs();
    print('JobListView initialized');
  }

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  Future<void> onSwipeRight(Job job) async {
    final user = AuthService.getCurrentUser();
    if (user == null) {
      _showLoginRequired();
      return;
    }

    bool shouldShow = await PreferencesService.shouldShowApplyConfirmation();
    if (shouldShow) {
      bool? confirmed = await _showApplyConfirmation(job);
      if (confirmed != true) return;
    }

    if (!AuthService.hasAppliedToJob(job.id)) {
      AuthService.addAppliedJob(job.id);
      widget.onJobApplied(job);
      
      // Create a new list without the applied job
      final newJobs = List<Job>.from(_jobs)..remove(job);
      print('Jobs after removal: ${newJobs.length} jobs remaining');
      newJobs.forEach((j) => print('- ${j.title}'));
      
      // Update state with new jobs list
      setState(() {
        _jobs = newJobs;
      });
    }
  }

  void onSwipeLeft() {
    if (_jobs.isEmpty) return;
    
    // Create a new list without the skipped job
    final newJobs = List<Job>.from(_jobs)..removeAt(0);
    print('Skipped job, ${newJobs.length} jobs remaining');
    
    // Update state with new jobs list
    setState(() {
      _jobs = newJobs;
    });
  }

  void _loadJobs() {
    final user = AuthService.getCurrentUser();
    final preferences = AuthService.getUserPreferences();
    
    if (user != null && preferences != null) {
      // Create a new list for jobs
      final newJobs = dummyJobs.where((job) {
        if (user.appliedJobs.contains(job.id)) {
          print('Job ${job.id} already applied');
          return false;
        }
        
        if (job.profession != preferences.profession) {
          print('Job ${job.id} profession mismatch: ${job.profession} != ${preferences.profession}');
          return false;
        }
        
        if (preferences.remoteOnly && !job.isRemote) {
          print('Job ${job.id} remote mismatch: user wants remote but job is not remote');
          return false;
        }
        
        if (preferences.preferredJobTypes.isNotEmpty && 
            !preferences.preferredJobTypes.contains(job.jobType)) {
          print('Job ${job.id} type mismatch: ${job.jobType} not in preferred types');
          return false;
        }
        
        print('Job ${job.id} matches all criteria: ${job.title}');
        return true;
      }).toList();

      setState(() {
        _jobs = newJobs;
        print('Loaded ${_jobs.length} jobs matching preferences');
        if (_jobs.isNotEmpty) {
          print('First job: ${_jobs.first.title}');
          _jobs.forEach((job) => print('- ${job.title} (${job.profession}, ${job.jobType}, remote: ${job.isRemote})'));
        } else {
          print('No jobs available');
        }
      });
    } else {
      setState(() {
        _jobs = [];
        print('No user or preferences found');
      });
    }
  }

  Widget _buildJobCards() {
    if (_jobs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.search_off,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                'No More Jobs Available',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Try adjusting your preferences in settings to see more jobs that match your profile.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final prefsUpdated = await Navigator.pushNamed(context, '/preferences');
                  if (prefsUpdated == true) {
                    _loadJobs();
                  }
                },
                child: const Text('Adjust Preferences'),
              ),
            ],
          ),
        ),
      );
    }

    return CardSwiper(
      cardBuilder: (context, index, horizontalThresholdPercentage,
          verticalThresholdPercentage) {
        if (index >= _jobs.length) return const SizedBox.shrink();
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
        if (previousIndex >= _jobs.length) return true;
        
        if (direction == CardSwiperDirection.right) {
          await onSwipeRight(_jobs[previousIndex]);
        } else if (direction == CardSwiperDirection.left) {
          onSwipeLeft();
        }
        return true;
      },
      numberOfCardsDisplayed: _calculateDisplayCount(_jobs.length),
      backCardOffset: const Offset(0, -8),
      padding: const EdgeInsets.only(bottom: 24),
      isDisabled: false,
      allowedSwipeDirection: AllowedSwipeDirection.only(left: true, right: true),
    );
  }

  int _calculateDisplayCount(int totalJobs) {
    if (totalJobs == 0) return 0;
    if (totalJobs == 1) return 1;
    if (totalJobs == 2) return 2;
    return 3; // Show max 3 cards for better performance and visual appeal
  }

  void _showLoginRequired() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Required'),
        content: const Text('Please login to apply for jobs.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/login');
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.star, size: 20, color: Colors.amber[700]),
                  const SizedBox(width: 4),
                  Text(
                    '${_jobs.length}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                  ),
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
              onPressed: () async {
                final prefsUpdated = await Navigator.pushNamed(context, '/preferences');
                if (prefsUpdated == true) {
                  _loadJobs();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: _buildJobCards(),
              ),
            ],
          ),
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
              Text('Are you sure you want to apply to ${job.title} at ${job.company}?'),
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
