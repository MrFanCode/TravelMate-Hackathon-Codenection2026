import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/airmail_stripe.dart';
import '../../../core/widgets/postmark_stamp.dart';
import '../../../core/widgets/primary_button.dart';
import '../providers/group_provider.dart';

/// Screen 10 — Preference Compromise Result.
class CompromiseResultScreen extends ConsumerStatefulWidget {
  final String tripId;
  final int day;
  const CompromiseResultScreen({super.key, required this.tripId, required this.day});

  @override
  ConsumerState<CompromiseResultScreen> createState() => _CompromiseResultScreenState();
}

class _CompromiseResultScreenState extends ConsumerState<CompromiseResultScreen> {
  bool _applying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(groupProvider).loadCompromise(widget.tripId, widget.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(groupProvider);
    final result = state.compromise;

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
                  icon: const Icon(Icons.arrow_back, color: AppColors.ink),
                ),
              ]),
            ),
            Expanded(
              child: state.isLoadingCompromise || result == null
                  ? const Center(child: CircularProgressIndicator(color: AppColors.rust))
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(24, 4, 24, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const PostmarkStamp(text: 'MATCH\nFOUND', size: 60, filled: true),
                          const SizedBox(height: 14),
                          Text('We found a compromise', style: AppTextStyles.displayMedium, textAlign: TextAlign.center),
                          Text('Split across your remaining days.', style: AppTextStyles.body, textAlign: TextAlign.center),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(child: _statCol('${result.majorityPick.voterCount}', 'Museum mornings')),
                              const SizedBox(width: 10),
                              Expanded(child: _statCol('${result.minorityPick.voterCount}', 'Beach afternoon')),
                            ],
                          ),
                          const SizedBox(height: 18),
                          _resultCard('Day ${result.majorityPick.day} — ${result.majorityPick.title}',
                              'Preferred by ${result.majorityPick.voterCount} of 4 voters'),
                          _resultCard('Day ${result.minorityPick.day} — ${result.minorityPick.title}',
                              'Preferred by ${result.minorityPick.voterCount} of 4 voters'),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: PrimaryButton(
                              label: _applying ? 'Applying…' : 'Apply to itinerary',
                              onPressed: _applying
                                  ? null
                                  : () async {
                                      setState(() => _applying = true);
                                      await ref.read(groupProvider).applyCompromise(widget.tripId);
                                      if (context.mounted) Navigator.of(context).maybePop();
                                    },
                            ),
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

  Widget _statCol(String big, String label) => Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.ink, width: 1.5),
        ),
        child: Column(
          children: [
            Text(big, style: AppTextStyles.displayMedium.copyWith(fontSize: 26)),
            const SizedBox(height: 4),
            Text(label, style: AppTextStyles.label.copyWith(fontSize: 9.5), textAlign: TextAlign.center),
          ],
        ),
      );

  Widget _resultCard(String title, String subtitle) => Container(
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
            Text(title, style: AppTextStyles.bodyStrong.copyWith(fontSize: 13.5)),
            Text(subtitle, style: AppTextStyles.body.copyWith(fontSize: 11.5)),
          ],
        ),
      );
}
