import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/airmail_stripe.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/progress_rail.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/interest_chip_card.dart';
import 'trip_type_screen.dart';

/// Screen 3 — Interest Tag Selection.
/// Allowed values match onboarding-api-contract.md exactly.
class InterestSelectionScreen extends ConsumerWidget {
  const InterestSelectionScreen({super.key});

  static const _interests = [
    {'tag': 'food_drink', 'label': 'Food & drink', 'icon': Icons.restaurant},
    {'tag': 'museums', 'label': 'Museums', 'icon': Icons.museum},
    {'tag': 'nature_hikes', 'label': 'Nature & hikes', 'icon': Icons.terrain},
    {'tag': 'history', 'label': 'History', 'icon': Icons.account_balance},
    {'tag': 'photography', 'label': 'Photography', 'icon': Icons.camera_alt},
    {'tag': 'nightlife', 'label': 'Nightlife', 'icon': Icons.nightlife},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AirmailStripe(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 24, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back, color: AppColors.ink),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ProgressRail(currentStep: 2),
                    const SizedBox(height: 12),
                    Text('Step 2 of 3', style: AppTextStyles.eyebrow),
                    const SizedBox(height: 4),
                    Text('What are you into?', style: AppTextStyles.displayMedium),
                    Text("Pick a few — we'll shape your days around them.", style: AppTextStyles.body),
                    const SizedBox(height: 18),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1.35,
                        children: _interests.map((i) {
                          final selected = state.data.interests.contains(i['tag']);
                          return InterestChipCard(
                            icon: i['icon'] as IconData,
                            label: i['label'] as String,
                            selected: selected,
                            onTap: () => ref.read(onboardingProvider).toggleInterest(i['tag'] as String),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    PrimaryButton(
                      label: '${state.data.interests.length} selected · Continue',
                      onPressed: state.data.interests.isEmpty
                          ? null
                          : () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const TripTypeScreen()),
                              );
                            },
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
