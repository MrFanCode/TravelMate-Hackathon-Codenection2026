import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/airmail_stripe.dart';
import '../models/itinerary_models.dart';
import '../providers/itinerary_provider.dart';

/// Screen 6 — Activity Detail. Same screen whether the activity came
/// from the AI-built plan or from a Map suggestion the user added.
class ActivityDetailScreen extends ConsumerWidget {
  final Activity activity;
  const ActivityDetailScreen({super.key, required this.activity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AirmailStripe(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back, color: AppColors.ink),
                        ),
                      ],
                    ),
                    // Postcard-style image placeholder — swap for a real
                    // photo once a places/image source is wired up.
                    Container(
                      height: 170,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.ink, width: 1.5),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.mustard, AppColors.rust, AppColors.pine],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(activity.title, style: AppTextStyles.displayMedium),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _tag('${activity.durationMin} min'),
                        _tag(activity.costUsd == 0 ? 'Free' : '\$${activity.costUsd.round()}'),
                        _tag(activity.locationName),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(activity.description, style: AppTextStyles.body),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.ink, width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () async {
                              await ref.read(itineraryProvider).removeActivity(activity.id);
                              if (context.mounted) Navigator.of(context).pop();
                            },
                            child: Text('Remove', style: AppTextStyles.bodyStrong),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.rust,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Keep in day', style: AppTextStyles.buttonLabel),
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

  Widget _tag(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.ink, width: 1.5),
        ),
        child: Text(label, style: AppTextStyles.label.copyWith(fontSize: 10.5, color: AppColors.ink)),
      );
}
