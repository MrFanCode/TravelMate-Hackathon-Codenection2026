import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// A dashed-circle "postmark" — used for progress steps, selection
/// confirmation, and general passport/ticket-style accents.
class PostmarkStamp extends StatelessWidget {
  final String text;
  final double size;
  final bool filled;

  const PostmarkStamp({
    super.key,
    required this.text,
    this.size = 52,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? AppColors.rust : AppColors.cream,
        border: Border.all(
          color: filled ? AppColors.rustDark : AppColors.ink,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyles.label.copyWith(
            fontSize: size * 0.18,
            color: filled ? AppColors.cream : AppColors.ink,
          ),
        ),
      ),
    );
  }
}
