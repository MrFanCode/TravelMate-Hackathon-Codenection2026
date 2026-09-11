import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/airmail_stripe.dart';
import '../../../core/widgets/primary_button.dart';
import 'trip_setup_screen.dart';

/// Screen 1 — Welcome. Pure UI, no API call.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AirmailStripe(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Trip planning, reimagined', style: AppTextStyles.eyebrow),
                        const SizedBox(height: 8),
                        Text('One trip.\nOne app.\nZero chaos.', style: AppTextStyles.displayLarge),
                        const SizedBox(height: 14),
                        Text(
                          "Itinerary, budget, group votes and disruption fixes — "
                          "all stamped into a single passport.",
                          style: AppTextStyles.body,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        PrimaryButton(
                          label: "Get started",
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const TripSetupScreen()),
                            );
                          },
                        ),
                        const SizedBox(height: 14),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'I already have an account',
                            style: AppTextStyles.bodyStrong.copyWith(
                              color: AppColors.inkSoft,
                              decoration: TextDecoration.underline,
                            ),
                          ),
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
    );
  }
}
