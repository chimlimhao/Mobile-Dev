import 'dart:math';
import 'package:flutter/material.dart';
import 'package:jobglide/models/model.dart';
import 'package:jobglide/screens/main/profile_screen.dart';
import 'package:jobglide/widgets/job_filter_dialog.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:jobglide/data/dummy_data.dart';
import 'package:jobglide/services/auth_service.dart';
import 'package:jobglide/services/application_service.dart';
import 'applications_screen.dart';

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
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          JobListView(onJobStatusChanged: _updateJobStatus),
          ApplicationsScreen(
            savedJobs: _savedJobs,
            appliedJobs: _appliedJobs,
          ),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Applications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
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
        if (_currentFilter.jobTypes.isNotEmpty &&
            !_currentFilter.jobTypes.contains(job.jobType)) {
          return false;
        }

        // Check remote only filter
        if (_currentFilter.remoteOnly && !job.isRemote) {
          return false;
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
    final isAutoApplyEnabled = AuthService.isAutoApplyEnabled();
    final status = isAutoApplyEnabled ? JobStatus.applied : JobStatus.saved;
    
    await AuthService.updateJobStatus(job.id, status);
    widget.onJobStatusChanged(job, status);
    
    // Remove the job from both lists
    setState(() {
      _allJobs.remove(job);
      _filteredJobs.remove(job);
    });
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

    // Create a new list to avoid modifying the original
    final displayJobs = List<Job>.from(_filteredJobs);
    
    return CardSwiper(
      controller: _cardController,
      cardsCount: displayJobs.length,
      numberOfCardsDisplayed: displayJobs.isEmpty ? 0 : 1,
      onSwipe: (previousIndex, currentIndex, direction) {
        if (previousIndex >= displayJobs.length) return true;
        
        if (direction == CardSwiperDirection.right) {
          _onSwipeRight(displayJobs[previousIndex]);
        } else if (direction == CardSwiperDirection.left) {
          _onSwipeLeft(displayJobs[previousIndex]);
        }
        return true;
      },
      cardBuilder: (context, index, _, __) {
        if (index >= displayJobs.length) {
          return const SizedBox.shrink();
        }
        return _buildJobCard(displayJobs[index]);
      },
    );
  }

  Widget _buildJobCard(Job job) {
    // Light mint green background
    final backgroundColor = Color(0xFFEDF3F0);
    
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              job.company,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 20, color: Colors.black54),
                const SizedBox(width: 4),
                Text(
                  job.location,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Remote',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    job.jobType.toString().split('.').last,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Medium Sized Company',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade200,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    job.salary,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Technology Services',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Bachelor\'s',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.pink.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Senior level',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'JobGlide',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, size: 28),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).primaryColor.withOpacity(0.05),
            ],
          ),
        ),
        child: _buildJobCards(),
      ),
    );
  }
}
