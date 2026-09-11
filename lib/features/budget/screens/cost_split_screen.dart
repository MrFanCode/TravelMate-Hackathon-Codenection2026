import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/airmail_stripe.dart';
import '../../../core/widgets/primary_button.dart';
import '../providers/budget_provider.dart';

/// Screen 13 — Cost Split Summary.
class CostSplitScreen extends ConsumerStatefulWidget {
  final String tripId;
  const CostSplitScreen({super.key, required this.tripId});

  @override
  ConsumerState<CostSplitScreen> createState() => _CostSplitScreenState();
}

class _CostSplitScreenState extends ConsumerState<CostSplitScreen> {
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(budgetProvider).loadSettleUp(widget.tripId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(budgetProvider);
    final settleUp = state.settleUp;

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
              child: state.isLoadingSettleUp || settleUp == null
                  ? const Center(child: CircularProgressIndicator(color: AppColors.rust))
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(24, 4, 24, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Settle up', style: AppTextStyles.eyebrow),
                          const SizedBox(height: 2),
                          Text('Who owes whom', style: AppTextStyles.displayMedium),
                          const SizedBox(height: 18),
                          ...settleUp.balances.map((b) => _row('${b.fromName} owes ${b.toName}', '\$${b.amountUsd.round()}', AppColors.rust)),
                          _row('You are owed', '\$${settleUp.yourNetUsd.round()}', AppColors.pine),
                          const Spacer(),
                          PrimaryButton(
                            label: _sending ? 'Sending…' : 'Send settle-up requests',
                            onPressed: _sending
                                ? null
                                : () async {
                                    setState(() => _sending = true);
                                    await ref.read(budgetProvider).notifySettleUp(widget.tripId);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Settle-up requests sent.')),
                                      );
                                      setState(() => _sending = false);
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

  Widget _row(String label, String amount, Color amountColor) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.ink, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyStrong.copyWith(fontSize: 13)),
          Text(amount, style: AppTextStyles.label.copyWith(fontSize: 13, color: amountColor)),
        ],
      ),
    );
  }
}
