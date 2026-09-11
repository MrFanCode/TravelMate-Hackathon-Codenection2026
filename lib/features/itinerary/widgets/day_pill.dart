import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class DayPill extends StatelessWidget {
  final int day;
  final bool active;
  final VoidCallback onTap;

  const DayPill({super.key, required this.day, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.ink : AppColors.cream,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.ink, width: 1.5),
        ),
        child: Text(
          'Day $day',
          style: AppTextStyles.label.copyWith(color: active ? AppColors.cream : AppColors.ink),
        ),
      ),
    );
  }
}
