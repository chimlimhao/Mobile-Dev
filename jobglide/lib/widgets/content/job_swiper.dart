import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:jobglide/models/models.dart';
import 'package:jobglide/widgets/content/job_card.dart';

class JobSwiper extends StatefulWidget {
  final CardSwiperController controller;
  final List<Job> jobs;
  final Function(Job) onSwipeRight;
  final Function(Job) onSwipeLeft;

  const JobSwiper({
    super.key,
    required this.controller,
    required this.jobs,
    required this.onSwipeRight,
    required this.onSwipeLeft,
  });

  @override
  State<JobSwiper> createState() => _JobSwiperState();
}

class _JobSwiperState extends State<JobSwiper> {
  bool _showEmptyState = false;

  @override
  void didUpdateWidget(JobSwiper oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only show empty state if we have no jobs and the old widget had jobs
    if (widget.jobs.isEmpty && oldWidget.jobs.isNotEmpty) {
      setState(() {
        _showEmptyState = true;
      });
    } else if (widget.jobs.isNotEmpty) {
      setState(() {
        _showEmptyState = false;
      });
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.work_off_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No jobs available',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new opportunities',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Only show empty state if explicitly set and we have no jobs
    if (_showEmptyState && widget.jobs.isEmpty) {
      return _buildEmptyState();
    }

    // If we have jobs, always try to show them
    if (widget.jobs.isNotEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 800,
              child: CardSwiper(
                controller: widget.controller,
                cardsCount: widget.jobs.length,
                numberOfCardsDisplayed: widget.jobs.length > 1 ? 2 : 1,
                backCardOffset: widget.jobs.length > 1
                    ? const Offset(0, 40)
                    : const Offset(0, 0),
                scale: 0.95,
                padding: const EdgeInsets.symmetric(vertical: 20),
                onSwipe: (previousIndex, currentIndex, direction) {
                  if (previousIndex >= widget.jobs.length) return true;

                  if (direction == CardSwiperDirection.right) {
                    widget.onSwipeRight(widget.jobs[previousIndex]);
                  } else if (direction == CardSwiperDirection.left) {
                    widget.onSwipeLeft(widget.jobs[previousIndex]);
                  }
                  return true;
                },
                cardBuilder:
                    (context, index, horizontalThreshold, verticalThreshold) {
                  if (index >= widget.jobs.length) {
                    return const SizedBox.shrink();
                  }
                  return JobCard(
                    job: widget.jobs[index],
                    index: index,
                  );
                },
              ),
            ),
          );
        },
      );
    }

    // If we're here, we have no jobs but haven't confirmed we're empty
    // Show a loading-like state instead of empty state
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
