import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/airmail_stripe.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/primary_button.dart';
import '../providers/group_provider.dart';
import '../widgets/vote_card.dart';
import 'compromise_result_screen.dart';
import '../../itinerary/screens/itinerary_screen.dart';
import '../../itinerary/screens/map_screen.dart';
import '../../budget/screens/budget_overview_screen.dart';

/// Screen 9 — Group Voting Dashboard. Has the bottom nav since it's a
/// main-app tab screen (Group tab), same pattern as Itinerary/Map.
class GroupVotingScreen extends ConsumerStatefulWidget {
  final String tripId;
  const GroupVotingScreen({super.key, required this.tripId});

  @override
  ConsumerState<GroupVotingScreen> createState() => _GroupVotingScreenState();
}

class _GroupVotingScreenState extends ConsumerState<GroupVotingScreen> {
  static const _day = 3; // the day currently up for a vote

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(groupProvider).loadProposals(widget.tripId, _day);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(groupProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const AirmailStripe(),
            Expanded(
              child: state.isLoadingProposals
                  ? const Center(child: CircularProgressIndicator(color: AppColors.rust))
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('4 travelers voting', style: AppTextStyles.eyebrow),
                          const SizedBox(height: 2),
                          Text('Vote on Day $_day', style: AppTextStyles.displayMedium),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView(
                              children: state.proposals
                                  .map((p) => VoteCard(
                                        proposal: p,
                                        selected: state.yourVote == p.id,
                                        onTap: () {
                                          ref.read(groupProvider).vote(widget.tripId, _day, p.id);
                                        },
                                      ))
                                  .toList(),
                            ),
                          ),
                          PrimaryButton(
                            label: 'See compromise',
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => CompromiseResultScreen(tripId: widget.tripId, day: _day),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
            ),
            AppBottomNavBar(
              current: MainTab.group,
              onSelect: (tab) {
                if (tab == MainTab.trip) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => ItineraryScreen(tripId: widget.tripId)),
                  );
                } else if (tab == MainTab.map) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => MapScreen(tripId: widget.tripId)),
                  );
                } else if (tab == MainTab.budget) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => BudgetOverviewScreen(tripId: widget.tripId)),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
