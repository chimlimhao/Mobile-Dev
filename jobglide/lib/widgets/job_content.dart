import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:jobglide/models/model.dart';
import 'package:jobglide/widgets/job_swiper.dart';

class JobContent extends StatelessWidget {
  final CardSwiperController cardController;
  final List<Job> filteredJobs;
  final Function(Job) onSwipeRight;
  final Function(Job) onSwipeLeft;
  final bool isLoading;

  const JobContent({
    super.key,
    required this.cardController,
    required this.filteredJobs,
    required this.onSwipeRight,
    required this.onSwipeLeft,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (filteredJobs.isEmpty) {
      return const EmptyJobsView();
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade100.withOpacity(0.8),
            Colors.blue.shade100,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: JobSwiper(
          controller: cardController,
          jobs: filteredJobs,
          onSwipeRight: onSwipeRight,
          onSwipeLeft: onSwipeLeft,
        ),
      ),
    );
  }
}

class EmptyJobsView extends StatelessWidget {
  const EmptyJobsView({super.key});

  @override
  Widget build(BuildContext context) {
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
            'No jobs available',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new opportunities',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
