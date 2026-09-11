import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/itinerary_models.dart';

/// One row in the day-by-day timeline (Screen 5). Tapping opens the
/// activity detail card (Screen 6).
class TimelineItem extends StatelessWidget {
  final Activity activity;
  final VoidCallback onTap;
  final bool isLast;

  const TimelineItem({super.key, required this.activity, required this.onTap, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.rust,
                ),
              ),
              if (!isLast) Expanded(child: Container(width: 1.5, color: AppColors.line)),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(activity.time, style: AppTextStyles.label.copyWith(fontSize: 10)),
                  const SizedBox(height: 3),
                  InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.cream,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.ink, width: 1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(activity.title, style: AppTextStyles.bodyStrong.copyWith(fontSize: 14)),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Text('${activity.durationMin} min', style: AppTextStyles.body.copyWith(fontSize: 11.5)),
                              const SizedBox(width: 10),
                              Text(
                                activity.costUsd == 0 ? 'Free' : '\$${activity.costUsd.round()}',
                                style: AppTextStyles.body.copyWith(fontSize: 11.5),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
