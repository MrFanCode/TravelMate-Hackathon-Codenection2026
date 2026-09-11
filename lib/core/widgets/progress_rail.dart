import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// The 3-segment progress bar shown on Trip Setup / Interests / Trip Type.
class ProgressRail extends StatelessWidget {
  final int totalSteps;
  final int currentStep; // 1-indexed

  const ProgressRail({super.key, this.totalSteps = 3, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (i) {
        final done = i < currentStep;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i == totalSteps - 1 ? 0 : 6),
            height: 4,
            decoration: BoxDecoration(
              color: done ? AppColors.rust : AppColors.line,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
