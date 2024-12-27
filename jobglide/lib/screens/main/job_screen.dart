import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:jobglide/models/models.dart';
import 'package:jobglide/services/application_service.dart';
import 'package:jobglide/services/auth_service.dart';
import 'package:jobglide/widgets/content/job_content.dart';
import 'package:jobglide/widgets/navigation/bottom_nav_bar.dart';
import 'package:jobglide/utils/snackbar_utils.dart';
import 'applications_screen.dart';
import 'package:jobglide/screens/main/profile_screen.dart';
import 'package:jobglide/screens/main/preferences_screen.dart';
import 'package:jobglide/widgets/app_bar/custom_app_bar.dart';

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
    // final user = AuthService.getCurrentUser();
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

  // Add a key to force rebuild of JobListView
  final _jobListKey = GlobalKey();

  Widget _buildBody() {
    return IndexedStack(
      index: _selectedIndex,
      children: [
        JobListView(
          key: _jobListKey,
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
        ProfileScreen(
          onDataReset: () {
            setState(() {
              _savedJobs.clear();
              _appliedJobs.clear();
              _rejectedJobs.clear();
              // Force rebuild of JobListView with a new key
              _jobListKey.currentState?.setState(() {});
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
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
  bool _isLoading = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  @override
  void didUpdateWidget(JobListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if any of the job lists have changed or if they're empty
    if (oldWidget.savedJobs.length != widget.savedJobs.length ||
        oldWidget.appliedJobs.length != widget.appliedJobs.length ||
        oldWidget.rejectedJobs.length != widget.rejectedJobs.length ||
        (_allJobs.isEmpty && _filteredJobs.isEmpty)) {
      _loadJobs();
    }
  }

  Future<void> _loadJobs() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final availableJobs = await ApplicationService.getAvailableJobs();
      print('Available jobs: ${availableJobs.length}');

      if (!mounted) return;

      final user = AuthService.getCurrentUser();
      final preferences = user.preferences;

      List<Job> filteredJobs = List<Job>.from(availableJobs);
      print(
          'User preferences: ${preferences.professions}, Remote: ${preferences.remoteOnly}, Types: ${preferences.preferredJobTypes}');

      // First, remove any jobs that are already in saved, applied, or rejected lists
      filteredJobs = filteredJobs.where((job) {
        return !widget.savedJobs.any((j) => j.id == job.id) &&
            !widget.appliedJobs.any((j) => j.id == job.id) &&
            !widget.rejectedJobs.any((j) => j.id == job.id);
      }).toList();

      print('Jobs after removing interactions: ${filteredJobs.length}');

      // Then apply preference filters
      if (preferences.professions.isNotEmpty ||
          preferences.remoteOnly ||
          preferences.preferredJobTypes.isNotEmpty) {
        filteredJobs = filteredJobs.where((job) {
          bool matchesJobType = true;
          bool matchesRemote = true;
          bool matchesProfession = true;

          // Helper function to check if a job is software development related
          bool isSoftwareJob(Job j) {
            final titleLower = j.title.toLowerCase();
            final professionLower = j.profession.toLowerCase();
            final descriptionLower = j.description.toLowerCase();

            final softwareKeywords = [
              'developer',
              'engineer',
              'software',
              'mobile',
              'flutter',
              'full stack',
              'backend',
              'frontend'
            ];

            return softwareKeywords.any((keyword) =>
                titleLower.contains(keyword) ||
                professionLower.contains(keyword) ||
                descriptionLower.contains(keyword));
          }

          // Check job type - allow both full time and contract for software roles
          if (preferences.preferredJobTypes.isNotEmpty) {
            final bool isSoftwareDev = isSoftwareJob(job);

            if (isSoftwareDev) {
              // For software jobs, be more lenient with job types
              matchesJobType = preferences.preferredJobTypes.any((type) =>
                  type == job.jobType ||
                  (type == JobType.fullTime &&
                      job.jobType == JobType.contract) ||
                  (type == JobType.contract &&
                      job.jobType == JobType.fullTime));
            } else {
              // For non-software jobs, strict matching
              matchesJobType =
                  preferences.preferredJobTypes.contains(job.jobType);
            }
          }

          // Check remote preference - be more lenient for software roles
          if (preferences.remoteOnly) {
            matchesRemote = job.isRemote || isSoftwareJob(job);
          }

          // Check profession with improved matching
          if (preferences.professions.isNotEmpty) {
            matchesProfession = preferences.professions.any((p) {
              final pLower = p.toLowerCase();

              // If looking for software developer, match any software development role
              if (pLower.contains('software') || pLower.contains('developer')) {
                return isSoftwareJob(job);
              }

              // For other professions, do direct matching
              return job.profession.toLowerCase().contains(pLower) ||
                  job.title.toLowerCase().contains(pLower);
            });
          }

          return matchesJobType && matchesRemote && matchesProfession;
        }).toList();
      }

      print('Final filtered jobs: ${filteredJobs.length}');

      if (!mounted) return;

      setState(() {
        _allJobs = List<Job>.from(availableJobs);
        // Update filtered jobs list, keeping any existing jobs not in the new list
        final existingJobIds = _filteredJobs.map((j) => j.id).toSet();
        final newJobs =
            filteredJobs.where((job) => !existingJobIds.contains(job.id));
        _filteredJobs.addAll(newJobs);
        _isLoading = false;
      });

      print('Current filtered jobs in state: ${_filteredJobs.length}');
    } catch (e) {
      print('Error loading jobs: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onSwipeRight(Job job) async {
    if (_isProcessing) return;

    final isAutoApplyEnabled = AuthService.isAutoApplyEnabled();
    setState(() {
      _isProcessing = true;
    });

    try {
      bool success = false;
      if (isAutoApplyEnabled) {
        success = await ApplicationService.applyToJob(job);

        if (mounted) {
          SnackbarUtils.showSnackBar(
            context,
            message: success
                ? 'Application sent successfully!'
                : 'Failed to send application. Job might already be applied or rejected.',
            isSuccess: success,
          );
        }

        if (success) {
          widget.onJobStatusChanged(job, JobStatus.applied);
        }
      } else {
        success = await ApplicationService.saveJob(job);
        if (success) {
          widget.onJobStatusChanged(job, JobStatus.saved);
          if (mounted) {
            SnackbarUtils.showSnackBar(
              context,
              message: 'Job saved! View it in your saved jobs.',
              isSuccess: true,
            );
          }
        } else if (mounted) {
          SnackbarUtils.showSnackBar(
            context,
            message: 'Job already saved or applied.',
            isSuccess: false,
          );
        }
      }

      if (success && mounted) {
        // Load more jobs first
        await _loadJobs();

        // Then remove the swiped job
        if (mounted) {
          setState(() {
            _filteredJobs.removeWhere((j) => j.id == job.id);
          });
        }
      }
    } catch (e) {
      print('Error handling swipe right: $e');
      if (mounted) {
        SnackbarUtils.showSnackBar(
          context,
          message: 'Something went wrong. Please try again.',
          isSuccess: false,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _onSwipeLeft(Job job) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Load more jobs first
      await _loadJobs();

      // Then store the job as rejected and update UI
      await ApplicationService.rejectJob(job);

      if (mounted) {
        setState(() {
          _filteredJobs.removeWhere((j) => j.id == job.id);
          widget.onJobStatusChanged(job, JobStatus.rejected);
        });
      }
    } catch (e) {
      print('Error handling swipe left: $e');
      if (mounted) {
        SnackbarUtils.showSnackBar(
          context,
          message: 'Something went wrong. Please try again.',
          isSuccess: false,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _applyUserPreferences() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get current user preferences
      final user = AuthService.getCurrentUser();
      final preferences = user.preferences;

      // If no preferences are set, show all jobs
      if (preferences.professions.isEmpty &&
          !preferences.remoteOnly &&
          preferences.preferredJobTypes.isEmpty) {
        setState(() {
          _filteredJobs = List<Job>.from(_allJobs);
          _isLoading = false;
        });
        return;
      }

      // Apply filters based on preferences
      final filteredJobs = _allJobs.where((job) {
        // Check job type
        if (preferences.preferredJobTypes.isNotEmpty) {
          if (!preferences.preferredJobTypes.contains(job.jobType)) {
            return false;
          }
        }

        // Check remote preference
        if (preferences.remoteOnly && !job.isRemote) {
          return false;
        }

        // Check profession
        if (preferences.professions.isNotEmpty) {
          bool matchesAnyProfession = preferences.professions.any((p) {
            final pLower = p.toLowerCase();
            return job.profession.toLowerCase() == pLower ||
                job.title.toLowerCase().contains(pLower) ||
                job.description.toLowerCase().contains(pLower);
          });
          if (!matchesAnyProfession) {
            return false;
          }
        }

        return true;
      }).toList();

      // Remove any jobs that are already in saved, applied, or rejected lists
      final availableJobs = filteredJobs.where((job) {
        return !widget.savedJobs.any((j) => j.id == job.id) &&
            !widget.appliedJobs.any((j) => j.id == job.id) &&
            !widget.rejectedJobs.any((j) => j.id == job.id);
      }).toList();

      if (mounted) {
        setState(() {
          _filteredJobs = availableJobs;
          _isLoading = false;
        });

        // If we have too few jobs after filtering, load more
        if (_filteredJobs.length <= 2) {
          _loadJobs();
        }
      }
    } catch (e) {
      debugPrint('Error applying preferences: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
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
          // After returning from preferences screen, apply the new preferences
          if (mounted) {
            _applyUserPreferences();
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
