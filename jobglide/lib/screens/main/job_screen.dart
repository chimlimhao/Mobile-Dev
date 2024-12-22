import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:jobglide/models/model.dart';
import 'package:jobglide/services/auth_service.dart';
import 'package:jobglide/widgets/job_filter_dialog.dart';
import 'package:jobglide/widgets/job_swiper.dart';
import 'package:jobglide/data/dummy_data.dart';
import 'package:jobglide/services/application_service.dart';
import 'applications_screen.dart';
import 'package:jobglide/screens/main/preferences_screen.dart';
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

  Widget _buildJobCards() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_filteredJobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.work_off,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              _allJobs.isEmpty
                  ? 'No more jobs available'
                  : 'No jobs match your filters',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _allJobs.isEmpty
                  ? 'Check back later for new opportunities'
                  : 'Try adjusting your filters to see more jobs',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            if (_allJobs.isNotEmpty) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _currentFilter = const JobFilter();
                    _applyFilter();
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reset Filters'),
              ),
            ],
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade100.withOpacity(0.8),  // Increased opacity and shade
            Colors.white,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: JobSwiper(
          controller: _cardController,
          jobs: _filteredJobs,
          onSwipeRight: _onSwipeRight,
          onSwipeLeft: _onSwipeLeft,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Auto Apply Toggle Button
            Container(
              child: Material(
                borderRadius: BorderRadius.circular(32),
                elevation: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: Colors.grey.shade100,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(32),
                    onTap: () {
                      setState(() {
                        AuthService.setAutoApplyEnabled(!AuthService.isAutoApplyEnabled());
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.flash_on,
                            color: AuthService.isAutoApplyEnabled()
                                ? Colors.amber.shade600
                                : Colors.grey.shade400,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Auto',
                            style: TextStyle(
                              color: AuthService.isAutoApplyEnabled()
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade600,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Screen Title
            const Text(
              'JobGlide',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            // Filter Button
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: _showFilterDialog,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
      body: _buildJobCards(),
    );
  }
}
