import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/airmail_stripe.dart';
import '../../../core/widgets/postmark_stamp.dart';
import '../../../core/widgets/primary_button.dart';
import '../providers/disruption_provider.dart';
import '../../itinerary/screens/itinerary_screen.dart';

/// Screen 15 — Replan Output. Diff view: removed items struck through,
/// added items highlighted. "Accept" writes the new day and returns to
/// the main app with the plan updated — closing the loop described in
/// README.md's app-flow diagram.
class ReplanOutputScreen extends ConsumerWidget {
  final String tripId;
  const ReplanOutputScreen({super.key, required this.tripId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(disruptionProvider);
    final diff = state.diff;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AirmailStripe(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back, color: AppColors.ink),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: PostmarkStamp(text: 'NEW\nPLAN', size: 36, filled: true),
                  ),
                ],
              ),
            ),
            Expanded(
              child: diff == null
                  ? const Center(child: CircularProgressIndicator(color: AppColors.rust))
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(24, 4, 24, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Day ${diff.day} — updated', style: AppTextStyles.displayMedium),
                          Text('Adjusted around your new landing time.', style: AppTextStyles.body),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView(
                              children: [
                                ...diff.removed.map((d) => _diffRow(d.time, d.title, removed: true)),
                                ...diff.added.map((d) => _diffRow(d.time, d.title, added: true)),
                                _diffRow('next', diff.unchangedNote),
                              ],
                            ),
                          ),
                          PrimaryButton(
                            label: state.isAccepting ? 'Applying…' : 'Accept new plan',
                            onPressed: state.isAccepting
                                ? null
                                : () async {
                                    await ref.read(disruptionProvider).acceptReplan(tripId);
                                    if (context.mounted) {
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (_) => ItineraryScreen(tripId: tripId)),
                                        (route) => false,
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

  Widget _diffRow(String time, String title, {bool removed = false, bool added = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: added ? const Color(0xFFEAF0EA) : AppColors.cream,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: added ? AppColors.pine : AppColors.ink, width: 1.5),
      ),
      child: Opacity(
        opacity: removed ? 0.5 : 1,
        child: Row(
          children: [
            SizedBox(width: 46, child: Text(time, style: AppTextStyles.label.copyWith(fontSize: 10))),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyStrong.copyWith(
                  fontSize: 12.5,
                  decoration: removed ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
