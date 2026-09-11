import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/airmail_stripe.dart';
import '../../../core/widgets/primary_button.dart';
import '../providers/location_provider.dart';

/// Received by other group members when someone taps "I need help" —
/// opens via push notification in production, same pattern as
/// disruption alerts (see disruption-api-contract.md for that precedent).
class SosAlertScreen extends ConsumerWidget {
  final String tripId;
  const SosAlertScreen({super.key, required this.tripId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(locationProvider);
    final sos = state.activeSos;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AirmailStripe(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 24, 0),
              child: Row(children: [
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.close, color: AppColors.ink),
                ),
              ]),
            ),
            Expanded(
              child: sos == null
                  ? Center(child: Text('No active alert.', style: AppTextStyles.body))
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(24, 4, 24, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.rust),
                            child: const Icon(Icons.priority_high, color: AppColors.cream, size: 34),
                          ),
                          const SizedBox(height: 14),
                          Text('${sos.fromName} needs help', style: AppTextStyles.displayMedium, textAlign: TextAlign.center),
                          Text('They shared their location with the group.', style: AppTextStyles.body, textAlign: TextAlign.center),
                          const SizedBox(height: 18),
                          // Stylized location preview — real Mapbox tiles wired up later, same as Screen 7.
                          Container(
                            height: 160,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.paper2,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.ink, width: 1.5),
                            ),
                            child: Center(
                              child: Container(
                                width: 30,
                                height: 30,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.rust,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.inkSoft, width: 1.5),
                                ),
                                child: Text(sos.fromName[0], style: AppTextStyles.label.copyWith(fontSize: 12, color: AppColors.cream)),
                              ),
                            ),
                          ),
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
                                  onPressed: () {},
                                  child: Text('Get directions', style: AppTextStyles.bodyStrong),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: PrimaryButton(
                                  label: 'Found them',
                                  onPressed: () async {
                                    await ref.read(locationProvider).resolveSos(tripId);
                                    if (context.mounted) Navigator.of(context).maybePop();
                                  },
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
