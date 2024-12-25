import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:jobglide/models/model.dart';
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
    if (widget.jobs.isEmpty) {
      setState(() {
        _showEmptyState = true;
      });
    } else {
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
    if (widget.jobs.isEmpty || _showEmptyState) {
      return _buildEmptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: 800,
          child: CardSwiper(
            controller: widget.controller,
            cardsCount: widget.jobs.length,
            numberOfCardsDisplayed: 1,
            scale: 0.95,
            padding: const EdgeInsets.symmetric(vertical: 20),
            onSwipe: (previousIndex, currentIndex, direction) {
              if (previousIndex >= widget.jobs.length) return true;
              
              if (direction == CardSwiperDirection.right) {
                widget.onSwipeRight(widget.jobs[previousIndex]);
              } else if (direction == CardSwiperDirection.left) {
                widget.onSwipeLeft(widget.jobs[previousIndex]);
              }

              // Check if we've reached the end of the cards
              if (currentIndex == null || currentIndex >= widget.jobs.length) {
                // Show empty state after a short delay to allow animation to complete
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (mounted) {
                    setState(() {
                      _showEmptyState = true;
                    });
                  }
                });
              }
              return true;
            },
            cardBuilder: (context, index, _, __) {
              if (index >= widget.jobs.length) {
                return const SizedBox.shrink();
              }
              return JobCard(
                job: widget.jobs[index],
                index: index,
              );
            },
          ),
        );
      },
    );
  }
}
