import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// The rust "ticket stub" CTA button used across onboarding — has the
/// small circular notches on either side, like a torn ticket.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool fullWidth;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Material(
            color: AppColors.rust,
            borderRadius: BorderRadius.circular(6),
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: onPressed,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Center(
                  child: Text(label.toUpperCase(), style: AppTextStyles.buttonLabel),
                ),
              ),
            ),
          ),
          // ticket notches
          Positioned(left: -7, child: _notch()),
          Positioned(right: -7, child: _notch()),
        ],
      ),
    );
  }

  Widget _notch() => Container(
        width: 14,
        height: 14,
        decoration: const BoxDecoration(
          color: AppColors.paper,
          shape: BoxShape.circle,
        ),
      );
}
