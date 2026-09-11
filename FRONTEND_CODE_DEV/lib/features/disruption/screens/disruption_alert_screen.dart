import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/airmail_stripe.dart';
import '../../../core/widgets/primary_button.dart';
import '../providers/disruption_provider.dart';
import 'replan_output_screen.dart';

/// Screen 14 — Flight Delay Alert. Modal-style (X to close), reached via
/// a push-notification tap in production — see disruption-api-contract.md.
class DisruptionAlertScreen extends ConsumerStatefulWidget {
  final String tripId;
  const DisruptionAlertScreen({super.key, required this.tripId});

  @override
  ConsumerState<DisruptionAlertScreen> createState() => _DisruptionAlertScreenState();
}

class _DisruptionAlertScreenState extends ConsumerState<DisruptionAlertScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(disruptionProvider).loadDisruption(widget.tripId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(disruptionProvider);
    final disruption = state.disruption;

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
              child: state.isLoadingDisruption || disruption == null
                  ? const Center(child: CircularProgressIndicator(color: AppColors.rust))
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(24, 4, 24, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.rust,
                              border: Border.all(color: AppColors.rustDark, width: 1.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.cream, width: 1.5),
                                  ),
                                  child: Text('DELAY\n3H', textAlign: TextAlign.center, style: AppTextStyles.label.copyWith(fontSize: 8, color: AppColors.cream)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(disruption.title, style: AppTextStyles.displayMedium.copyWith(fontSize: 16, color: AppColors.cream)),
                                      const SizedBox(height: 3),
                                      Text(disruption.description, style: AppTextStyles.body.copyWith(fontSize: 12, color: AppColors.paper)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text('Affected today', style: AppTextStyles.label),
                          const SizedBox(height: 8),
                          ...disruption.affectedActivities.map((a) => Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.cream,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.ink, width: 1.5),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(a.title, style: AppTextStyles.bodyStrong.copyWith(fontSize: 13.5)),
                                    Text(a.reason, style: AppTextStyles.body.copyWith(fontSize: 11.5)),
                                  ],
                                ),
                              )),
                          const Spacer(),
                          PrimaryButton(
                            label: state.isReplanning ? 'Replanning…' : 'Replan this day',
                            onPressed: state.isReplanning
                                ? null
                                : () async {
                                    await ref.read(disruptionProvider).requestReplan(widget.tripId);
                                    if (context.mounted) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (_) => ReplanOutputScreen(tripId: widget.tripId)),
                                      );
                                    }
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
