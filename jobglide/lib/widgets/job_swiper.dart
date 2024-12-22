import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:jobglide/models/model.dart';
import 'package:jobglide/widgets/job_card.dart';

class JobSwiper extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          // height: constraints.maxHeight * 0.7, // 70% of screen height
          height: 800,
          child: CardSwiper(
            controller: controller,
            cardsCount: jobs.length,
            numberOfCardsDisplayed: jobs.isEmpty ? 0 : 1,
            scale: 0.95,
            padding: const EdgeInsets.symmetric(vertical: 20),
            onSwipe: (previousIndex, currentIndex, direction) {
              if (previousIndex >= jobs.length) return true;
              
              if (direction == CardSwiperDirection.right) {
                onSwipeRight(jobs[previousIndex]);
              } else if (direction == CardSwiperDirection.left) {
                onSwipeLeft(jobs[previousIndex]);
              }
              return true;
            },
            cardBuilder: (context, index, _, __) {
              if (index >= jobs.length) {
                return const SizedBox.shrink();
              }
              return JobCard(
                job: jobs[index],
                index: index,
              );
            },
          ),
        );
      },
    );
  }
}
