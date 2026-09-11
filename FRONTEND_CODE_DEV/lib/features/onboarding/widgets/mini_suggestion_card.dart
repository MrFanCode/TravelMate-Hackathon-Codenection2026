import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// The flight/hotel pick-one card shown on Trip Setup (screen 2).
class MiniSuggestionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool picked;
  final VoidCallback onTap;

  const MiniSuggestionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.picked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: picked ? AppColors.paper2 : AppColors.cream,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: picked ? AppColors.rust : AppColors.ink, width: 1.5),
        ),
        child: Row(
          children: [
            CircleAvatar(radius: 15, backgroundColor: AppColors.ink, child: Icon(icon, size: 15, color: AppColors.paper)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyStrong.copyWith(fontSize: 12.5)),
                  Text(subtitle, style: AppTextStyles.body.copyWith(fontSize: 10.5)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: picked ? AppColors.rust : Colors.transparent,
                border: Border.all(color: AppColors.rust),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                picked ? 'PICKED' : 'PICK',
                style: AppTextStyles.label.copyWith(
                  fontSize: 9,
                  color: picked ? AppColors.cream : AppColors.rust,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
