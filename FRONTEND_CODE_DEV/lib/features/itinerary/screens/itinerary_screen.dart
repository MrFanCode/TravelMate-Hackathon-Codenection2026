import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/airmail_stripe.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../providers/itinerary_provider.dart';
import '../widgets/day_pill.dart';
import '../widgets/timeline_item.dart';
import 'activity_detail_screen.dart';
import 'map_screen.dart';
import '../../group_sync/screens/group_voting_screen.dart';
import '../../budget/screens/budget_overview_screen.dart';
import '../../disruption/screens/disruption_alert_screen.dart';

/// Screen 5 — AI Itinerary Output. First screen with the bottom nav bar,
/// since this is the entry point into the main (post-onboarding) app.
class ItineraryScreen extends ConsumerStatefulWidget {
  final String tripId;
  const ItineraryScreen({super.key, required this.tripId});

  @override
  ConsumerState<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends ConsumerState<ItineraryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(itineraryProvider).loadTrip(widget.tripId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(itineraryProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const AirmailStripe(),
            Expanded(
              child: state.isLoading || state.trip == null
                  ? const Center(child: CircularProgressIndicator(color: AppColors.rust))
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${state.trip!.destination} · trip plan', style: AppTextStyles.eyebrow),
                              // DEMO ONLY — in production this screen is opened by tapping
                              // a push notification (see disruption-api-contract.md), not
                              // by a button. This icon exists purely so the flow is reachable
                              // for testing/demo without a real Cloud Function running.
                              IconButton(
                                tooltip: 'Simulate a disruption (demo only)',
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => DisruptionAlertScreen(tripId: widget.tripId),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.notifications_active_outlined, size: 20, color: AppColors.rust),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text('Your trip', style: AppTextStyles.displayMedium),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 36,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: state.trip!.days
                                  .map((d) => DayPill(
                                        day: d.day,
                                        active: d.day == state.selectedDay,
                                        onTap: () => ref.read(itineraryProvider).selectDay(d.day),
                                      ))
                                  .toList(),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Expanded(
                            child: state.currentDay!.activities.isEmpty
                                ? Center(
                                    child: Text(
                                      'No activities planned yet for this day.',
                                      style: AppTextStyles.body,
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: state.currentDay!.activities.length,
                                    itemBuilder: (context, i) {
                                      final activities = state.currentDay!.activities;
                                      return TimelineItem(
                                        activity: activities[i],
                                        isLast: i == activities.length - 1,
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => ActivityDetailScreen(activity: activities[i]),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
            ),
            AppBottomNavBar(
              current: MainTab.trip,
              onSelect: (tab) {
                if (tab == MainTab.map) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => MapScreen(tripId: widget.tripId)),
                  );
                } else if (tab == MainTab.group) {
                  if (state.trip?.tripType == 'group') {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => GroupVotingScreen(tripId: widget.tripId)),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("This is a solo trip — no group to sync with.")),
                    );
                  }
                } else if (tab == MainTab.budget) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => BudgetOverviewScreen(tripId: widget.tripId)),
                  );
                }
                // (No further tabs to handle.)
              },
            ),
          ],
        ),
      ),
    );
  }
}
