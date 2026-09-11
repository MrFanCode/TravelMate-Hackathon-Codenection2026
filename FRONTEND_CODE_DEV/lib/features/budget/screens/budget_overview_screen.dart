import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/airmail_stripe.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../providers/budget_provider.dart';
import 'expense_logger_screen.dart';
import 'cost_split_screen.dart';
import '../../itinerary/screens/itinerary_screen.dart';
import '../../itinerary/screens/map_screen.dart';
import '../../group_sync/screens/group_voting_screen.dart';
import '../../itinerary/providers/itinerary_provider.dart';

const _categoryLabels = {
  'food_drink': 'Food',
  'lodging': 'Lodging',
  'activity': 'Activities',
  'transport': 'Transport',
};
const _categoryColors = {
  'food_drink': AppColors.rust,
  'lodging': AppColors.pine,
  'activity': AppColors.mustard,
  'transport': AppColors.inkSoft,
};

/// Screen 12 — Budget Overview. Main-app tab screen (Budget tab).
class BudgetOverviewScreen extends ConsumerStatefulWidget {
  final String tripId;
  const BudgetOverviewScreen({super.key, required this.tripId});

  @override
  ConsumerState<BudgetOverviewScreen> createState() => _BudgetOverviewScreenState();
}

class _BudgetOverviewScreenState extends ConsumerState<BudgetOverviewScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(budgetProvider).loadSummary(widget.tripId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(budgetProvider);
    final summary = state.summary;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const AirmailStripe(),
            Expanded(
              child: state.isLoadingSummary || summary == null
                  ? const Center(child: CircularProgressIndicator(color: AppColors.rust))
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Trip budget', style: AppTextStyles.eyebrow),
                          const SizedBox(height: 2),
                          Text('\$${summary.spentUsd.round()} of \$${summary.budgetUsd.round()}', style: AppTextStyles.displayMedium),
                          const SizedBox(height: 16),
                          Center(
                            child: SizedBox(
                              width: 150,
                              height: 150,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 150,
                                    height: 150,
                                    child: CircularProgressIndicator(
                                      value: summary.ratio,
                                      strokeWidth: 12,
                                      backgroundColor: AppColors.line,
                                      color: AppColors.rust,
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('${(summary.ratio * 100).round()}%', style: AppTextStyles.displayMedium.copyWith(fontSize: 22)),
                                      Text('SPENT', style: AppTextStyles.label.copyWith(fontSize: 9)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Expanded(
                            child: ListView(
                              children: summary.categories.map((c) {
                                final maxSpend = summary.categories.map((x) => x.spentUsd).reduce((a, b) => a > b ? a : b);
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 10, height: 10,
                                        decoration: BoxDecoration(shape: BoxShape.circle, color: _categoryColors[c.category]),
                                      ),
                                      const SizedBox(width: 10),
                                      SizedBox(
                                        width: 74,
                                        child: Text(_categoryLabels[c.category] ?? c.category, style: AppTextStyles.bodyStrong.copyWith(fontSize: 12)),
                                      ),
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(3),
                                          child: LinearProgressIndicator(
                                            value: maxSpend == 0 ? 0 : c.spentUsd / maxSpend,
                                            minHeight: 6,
                                            backgroundColor: AppColors.line,
                                            color: _categoryColors[c.category],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text('\$${c.spentUsd.round()}', style: AppTextStyles.label.copyWith(fontSize: 11)),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.ink, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => CostSplitScreen(tripId: widget.tripId)),
                      ),
                      child: Text('Settle up', style: AppTextStyles.bodyStrong),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.rust,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => ExpenseLoggerScreen(tripId: widget.tripId)),
                        );
                        if (context.mounted) ref.read(budgetProvider).loadSummary(widget.tripId);
                      },
                      child: Text('+ Log expense', style: AppTextStyles.buttonLabel),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            AppBottomNavBar(
              current: MainTab.budget,
              onSelect: (tab) async {
                if (tab == MainTab.trip) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => ItineraryScreen(tripId: widget.tripId)));
                } else if (tab == MainTab.map) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => MapScreen(tripId: widget.tripId)));
                } else if (tab == MainTab.group) {
                  final itinerary = ref.read(itineraryProvider);
                  if (itinerary.trip == null) await itinerary.loadTrip(widget.tripId);
                  if (!context.mounted) return;
                  if (itinerary.trip?.tripType == 'group') {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => GroupVotingScreen(tripId: widget.tripId)));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("This is a solo trip — no group to sync with.")),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
