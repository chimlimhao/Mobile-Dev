import 'package:flutter/material.dart';
import 'package:jobglide/models/models.dart';
import 'package:jobglide/screens/job_detail_screen.dart';
import 'package:jobglide/services/application_service.dart';

class ApplicationsScreen extends StatefulWidget {
  final List<Job> savedJobs;
  final List<Job> appliedJobs;
  final List<Job> rejectedJobs;
  final Function(Job, JobStatus) onJobStatusChanged;

  const ApplicationsScreen({
    super.key,
    required this.savedJobs,
    required this.appliedJobs,
    required this.rejectedJobs,
    required this.onJobStatusChanged,
  });

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Text(
          'Applications',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).colorScheme.primary,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(text: 'Saved'),
            Tab(text: 'Applied'),
            Tab(text: 'Removed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildJobList(widget.savedJobs, true),
          _buildJobList(widget.appliedJobs, false),
          _buildRejectedList(),
        ],
      ),
    );
  }

  Widget _buildJobList(List<Job> jobs, bool isSaved) {
    if (jobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSaved ? Icons.bookmark_border : Icons.work_outline,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              isSaved ? 'No saved jobs yet' : 'No applied jobs yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isSaved
                  ? 'Jobs you save will appear here'
                  : 'Jobs you apply to will appear here',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        return Dismissible(
          key: Key(job.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          onDismissed: (direction) async {
            final jobsList = isSaved ? widget.savedJobs : widget.appliedJobs;
            final jobIndex = jobsList.indexOf(job);
            setState(() {
              jobsList.removeAt(jobIndex);
            });

            await ApplicationService.deleteJob(
              job,
              isSaved ? JobStatus.saved : JobStatus.applied,
            );

            widget.onJobStatusChanged(job, JobStatus.rejected);

            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${job.title} removed'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () async {
                    setState(() {
                      jobsList.insert(jobIndex, job);
                    });

                    if (isSaved) {
                      await ApplicationService.saveJob(job);
                    } else {
                      await ApplicationService.applyToJob(job);
                    }

                    widget.onJobStatusChanged(
                      job,
                      isSaved ? JobStatus.saved : JobStatus.applied,
                    );
                  },
                ),
              ),
            );
          },
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JobDetailScreen(
                    job: job,
                    isSaved: isSaved,
                    onApply: (job) async {
                      await ApplicationService.applyToJob(job);
                      widget.onJobStatusChanged(job, JobStatus.applied);
                    },
                    onUnsave: (job) async {
                      await ApplicationService.deleteJob(job, JobStatus.saved);
                      widget.onJobStatusChanged(job, JobStatus.rejected);
                    },
                  ),
                ),
              );
            },
            title: Text(
              job.title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              '${job.company} • ${job.location}',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            trailing: Icon(
              isSaved ? Icons.bookmark : Icons.check_circle,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        );
      },
    );
  }

  Widget _buildRejectedList() {
    if (widget.rejectedJobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delete_outline,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No removed jobs',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Jobs you remove will appear here',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: widget.rejectedJobs.length,
      itemBuilder: (context, index) {
        final job = widget.rejectedJobs[index];
        return Dismissible(
          key: Key('rejected_${job.id}'),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Theme.of(context).colorScheme.primary,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: const Icon(
              Icons.restore,
              color: Colors.white,
            ),
          ),
          onDismissed: (direction) async {
            await ApplicationService.restoreJob(job);
            widget.onJobStatusChanged(job, JobStatus.saved);

            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${job.title} restored to saved jobs'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () async {
                    await ApplicationService.rejectJob(job);
                    widget.onJobStatusChanged(job, JobStatus.rejected);
                  },
                ),
              ),
            );
          },
          child: ListTile(
            title: Text(
              job.title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              '${job.company} • ${job.location}',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            trailing: TextButton.icon(
              onPressed: () async {
                await ApplicationService.restoreJob(job);
                widget.onJobStatusChanged(job, JobStatus.saved);
              },
              icon: const Icon(Icons.restore),
              label: const Text('Restore'),
            ),
          ),
        );
      },
    );
  }
}
