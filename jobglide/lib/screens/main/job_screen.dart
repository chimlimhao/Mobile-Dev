import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:jobglide/models/model.dart';
import 'package:jobglide/services/application_service.dart';
import 'package:jobglide/services/auth_service.dart';
import 'package:jobglide/widgets/content/job_filter_dialog.dart';
import 'package:jobglide/widgets/content/job_swiper.dart';
import 'package:jobglide/data/dummy_data.dart';
import 'package:jobglide/widgets/app_bar/job_app_bar.dart';
import 'package:jobglide/widgets/content/job_content.dart';
import 'package:jobglide/widgets/navigation/bottom_nav_bar.dart';
import 'applications_screen.dart';
import 'package:jobglide/screens/main/profile_screen.dart';
import 'package:jobglide/screens/main/preferences_screen.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  int _selectedIndex = 0;
  final List<Job> _savedJobs = [];
  final List<Job> _appliedJobs = [];
  final List<Job> _rejectedJobs = [];

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    final user = AuthService.getCurrentUser();
    if (user != null) {
      final savedJobs = await ApplicationService.getSavedJobs();
      final appliedJobs = await ApplicationService.getAppliedJobs();
      final rejectedJobs = await ApplicationService.getRejectedJobs();

      setState(() {
        _savedJobs
          ..clear()
          ..addAll(savedJobs);
        _appliedJobs
          ..clear()
          ..addAll(appliedJobs);
        _rejectedJobs
          ..clear()
          ..addAll(rejectedJobs);
      });
    }
  }

  void _updateJobStatus(Job job, JobStatus status) {
    setState(() {
      // Remove from all lists first
      _savedJobs.remove(job);
      _appliedJobs.remove(job);
      _rejectedJobs.remove(job);

      // Add to appropriate list
      switch (status) {
        case JobStatus.saved:
          _savedJobs.add(job);
          break;
        case JobStatus.applied:
          _appliedJobs.add(job);
          break;
        case JobStatus.rejected:
          _rejectedJobs.add(job);
          break;
        default:
          break;
      }
    });
  }

  Widget _buildBody() {
    return IndexedStack(
      index: _selectedIndex,
      children: [
        JobListView(
          savedJobs: _savedJobs,
          appliedJobs: _appliedJobs,
          rejectedJobs: _rejectedJobs,
          onJobStatusChanged: _updateJobStatus,
        ),
        ApplicationsScreen(
          savedJobs: _savedJobs,
          appliedJobs: _appliedJobs,
          rejectedJobs: _rejectedJobs,
          onJobStatusChanged: _updateJobStatus,
        ),
        const ProfileScreen(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}

class JobListView extends StatefulWidget {
  final List<Job> savedJobs;
  final List<Job> appliedJobs;
  final List<Job> rejectedJobs;
  final Function(Job, JobStatus) onJobStatusChanged;

  const JobListView({
    super.key,
    required this.savedJobs,
    required this.appliedJobs,
    required this.rejectedJobs,
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
  bool _isProcessing = false;

  void _handleJobApplication(Job job) async {
    final success = await ApplicationService.applyToJob(job);
    if (success) {
      setState(() {
        _allJobs.remove(job);
        _filteredJobs.remove(job);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Application sent successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
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
    setState(() {
      _isLoading = true;
    });

    try {
      // Get user's saved and applied jobs
      final savedJobs = widget.savedJobs;
      final appliedJobs = widget.appliedJobs;
      final rejectedJobs = widget.rejectedJobs;

      // Filter out jobs that user has already interacted with
      final availableJobs = dummyJobs.where((job) {
        return !savedJobs.any((saved) => saved.id == job.id) &&
            !appliedJobs.any((applied) => applied.id == job.id) &&
            !rejectedJobs.any((rejected) => rejected.id == job.id);
      }).toList();

      setState(() {
        _allJobs = availableJobs;
        _applyFilter();
      });
    } catch (e) {
      print('Error loading jobs: $e');
      setState(() {
        _allJobs = dummyJobs;
        _applyFilter();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilter() {
    setState(() {
      _filteredJobs =
          _allJobs.where((job) => _currentFilter.matches(job)).toList();
    });
  }

  Future<void> _onSwipeRight(Job job) async {
    final isAutoApplyEnabled = AuthService.isAutoApplyEnabled();

    setState(() {
      _isProcessing = true;
    });

    try {
      if (isAutoApplyEnabled) {
        // Apply to the job
        final success = await ApplicationService.applyToJob(job);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                success
                    ? 'Application sent successfully!'
                    : 'Failed to send application. Please try again.',
              ),
              backgroundColor: success ? Colors.green : Colors.red,
            ),
          );
        }

        if (success) {
          widget.onJobStatusChanged(job, JobStatus.applied);
        }
      } else {
        // Just save the job if auto-apply is disabled
        await ApplicationService.saveJob(job);
        widget.onJobStatusChanged(job, JobStatus.saved);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Job saved! View it in your saved jobs.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      // Remove the job from the list regardless of success
      setState(() {
        _allJobs.remove(job);
        _filteredJobs.remove(job);
      });
    } catch (e) {
      print('Error handling swipe right: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _onSwipeLeft(Job job) {
    setState(() {
      _allJobs.remove(job);
      _filteredJobs.remove(job);
      widget.onJobStatusChanged(job, JobStatus.rejected);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JobAppBar(
        onFilterPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PreferencesScreen()),
          );
          // After returning from preferences screen, update the jobs list
          if (mounted) {
            final user = AuthService.getCurrentUser();
            if (user != null) {
              setState(() {
                // Update filter based on user preferences
                _currentFilter = JobFilter(
                  jobTypes: user.preferences.preferredJobTypes,
                  remoteOnly: user.preferences.remoteOnly,
                  professions: user.preferences.professions,
                );
                _loadJobs();
              });
            }
          }
        },
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
