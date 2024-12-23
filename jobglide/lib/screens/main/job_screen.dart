import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:jobglide/models/model.dart';
import 'package:jobglide/services/auth_service.dart';
import 'package:jobglide/widgets/job_filter_dialog.dart';
import 'package:jobglide/widgets/job_swiper.dart';
import 'package:jobglide/data/dummy_data.dart';
import 'package:jobglide/services/application_service.dart';
import 'package:jobglide/widgets/job_app_bar.dart';
import 'package:jobglide/widgets/job_content.dart';
import 'applications_screen.dart';
import 'package:jobglide/screens/main/profile_screen.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  int _selectedIndex = 0;
  final List<Job> _savedJobs = [];
  final List<Job> _appliedJobs = [];

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  void _loadJobs() {
    final user = AuthService.getCurrentUser();
    if (user != null) {
      setState(() {
        _savedJobs.clear();
        _appliedJobs.clear();
        
        // Sort jobs by status
        for (final job in dummyJobs) {
          final status = user.jobStatuses[job.id];
          if (status == JobStatus.saved) {
            _savedJobs.add(job);
          } else if (status == JobStatus.applied) {
            _appliedJobs.add(job);
          }
        }
      });
    }
  }

  void _updateJobStatus(Job job, JobStatus status) {
    setState(() {
      if (status == JobStatus.saved && !_savedJobs.contains(job)) {
        _savedJobs.add(job);
        _appliedJobs.remove(job);
      } else if (status == JobStatus.applied && !_appliedJobs.contains(job)) {
        _appliedJobs.add(job);
        _savedJobs.remove(job);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey.shade100,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                JobListView(
                  onJobStatusChanged: _updateJobStatus,
                ),
                ApplicationsScreen(
                  savedJobs: _savedJobs,
                  appliedJobs: _appliedJobs,
                  onJobStatusChanged: _updateJobStatus,
                ),
                const ProfileScreen(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        backgroundColor: Colors.white,
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.work_outline),
            selectedIcon: Icon(Icons.work),
            label: 'Jobs',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder),
            label: 'Applications',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class JobListView extends StatefulWidget {
  final Function(Job, JobStatus) onJobStatusChanged;

  const JobListView({
    super.key,
    required this.onJobStatusChanged,
  });

  @override
  State<JobListView> createState() => _JobListViewState();
}

class _JobListViewState extends State<JobListView> {
  final CardSwiperController _cardController = CardSwiperController();
  List<Job> _allJobs = [];
  List<Job> _filteredJobs = [];
  JobFilter _currentFilter = const JobFilter();
  bool _isLoading = true;

  void _handleJobApplication(Job job) {
    ApplicationService.applyToJob(
      context,
      job,
      onApplicationComplete: (bool applied) {
        if (applied) {
          setState(() {
            _allJobs.remove(job);
            _filteredJobs.remove(job);
          });
          widget.onJobStatusChanged(job, JobStatus.applied);
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  Future<void> _loadJobs() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    final user = AuthService.getCurrentUser();
    if (user != null) {
      // Filter out jobs that user has already interacted with
      final availableJobs = dummyJobs.where((job) {
        final status = user.jobStatuses[job.id];
        return status == null; // Only show jobs with no status (not saved/applied)
      }).toList();

      setState(() {
        _allJobs = availableJobs;
        _applyFilter();
        _isLoading = false;
      });
    } else {
      setState(() {
        _allJobs = dummyJobs;
        _applyFilter();
        _isLoading = false;
      });
    }
  }

  void _applyFilter() {
    setState(() {
      _filteredJobs = _allJobs.where((job) {
        // Check job type filter
        if (_currentFilter.jobTypes?.isNotEmpty ?? false) {
          if (!(_currentFilter.jobTypes?.contains(job.jobType) ?? false)) {
            return false;
          }
        }

        // Check remote only filter
        if (_currentFilter.remoteOnly ?? false) {
          if (!job.isRemote) {
            return false;
          }
        }

        // Check search query
        if (_currentFilter.searchQuery?.isNotEmpty ?? false) {
          final query = _currentFilter.searchQuery!.toLowerCase();
          return job.title.toLowerCase().contains(query) ||
              job.company.toLowerCase().contains(query) ||
              job.description.toLowerCase().contains(query);
        }

        return true;
      }).toList();
    });
  }

  Future<void> _showFilterDialog() async {
    final result = await showDialog<JobFilter>(
      context: context,
      builder: (context) => JobFilterDialog(
        initialFilter: _currentFilter,
        onApply: (filter) {
          setState(() {
            _currentFilter = filter;
            _applyFilter();
          });
        },
      ),
    );

    if (result != null) {
      setState(() {
        _currentFilter = result;
        _applyFilter();
      });
    }
  }

  Future<void> _onSwipeRight(Job job) async {
    if (AuthService.isAutoApplyEnabled()) {
      _handleJobApplication(job);
    } else {
      setState(() {
        widget.onJobStatusChanged(job, JobStatus.saved);
      });
    }
  }

  void _onSwipeLeft(Job job) {
    // Remove the job from both lists
    setState(() {
      _allJobs.remove(job);
      _filteredJobs.remove(job);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JobAppBar(
        onFilterPressed: _showFilterDialog,
      ),
      body: JobContent(
        cardController: _cardController,
        filteredJobs: _filteredJobs,
        onSwipeRight: _onSwipeRight,
        onSwipeLeft: _onSwipeLeft,
        isLoading: _isLoading,
      ),
    );
  }
}
