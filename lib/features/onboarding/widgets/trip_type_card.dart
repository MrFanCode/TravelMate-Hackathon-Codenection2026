import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// The Solo / Group choice card on screen 4, with the rotated
/// "SELECTED" postmark shown when picked.
class TripTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const TripTypeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected ? AppColors.paper2 : AppColors.cream,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppColors.rust : AppColors.ink, width: selected ? 2 : 1.5),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(radius: 22, backgroundColor: AppColors.ink, child: Icon(icon, color: AppColors.paper, size: 20)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyles.displayMedium.copyWith(fontSize: 19)),
                      const SizedBox(height: 4),
                      Text(subtitle, style: AppTextStyles.body.copyWith(fontSize: 12.5)),
                    ],
                  ),
                ),
              ],
            ),
            if (selected)
              Positioned(
                top: 0,
                right: 0,
                child: Transform.rotate(
                  angle: -0.25,
                  child: Container(
                    width: 46,
                    height: 46,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.rust, width: 1.5, style: BorderStyle.solid),
                    ),
                    child: Text(
                      'SELECTED\n✓',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.label.copyWith(fontSize: 7, color: AppColors.rust),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
