import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// One tappable interest tile on screen 3 (Interest Tag Selection).
class InterestChipCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const InterestChipCard({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.rust : AppColors.cream,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? AppColors.rustDark : AppColors.ink, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: selected ? AppColors.cream : AppColors.ink),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.bodyStrong.copyWith(
                      fontSize: 13,
                      color: selected ? AppColors.cream : AppColors.ink,
                    ),
                  ),
                ),
                if (selected)
                  const Icon(Icons.check_circle, size: 16, color: AppColors.cream),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
