import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/airmail_stripe.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/progress_rail.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/trip_type_card.dart';
import '../../itinerary/screens/itinerary_screen.dart';
import '../../group_sync/screens/group_invite_screen.dart';

/// Screen 4 — Solo vs Group. Submits POST /trips on continue.
class TripTypeScreen extends ConsumerWidget {
  const TripTypeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider);

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
                    const ProgressRail(currentStep: 3),
                    const SizedBox(height: 12),
                    Text('Step 3 of 3', style: AppTextStyles.eyebrow),
                    const SizedBox(height: 4),
                    Text('Traveling solo,\nor with others?', style: AppTextStyles.displayMedium),
                    Text('This changes how we build your itinerary.', style: AppTextStyles.body),
                    const SizedBox(height: 22),
                    TripTypeCard(
                      icon: Icons.person,
                      title: 'Solo',
                      subtitle: 'Just you. We generate the whole plan around your pace and budget.',
                      selected: state.data.tripType == 'solo',
                      onTap: () => notifier.setTripType('solo'),
                    ),
                    TripTypeCard(
                      icon: Icons.groups,
                      title: 'Group',
                      subtitle: 'Invite friends, vote on activities, split costs automatically.',
                      selected: state.data.tripType == 'group',
                      onTap: () => notifier.setTripType('group'),
                    ),
                    const Spacer(),
                    PrimaryButton(
                      label: state.isCreatingTrip ? 'Building your trip…' : "Let's plan your trip",
                      onPressed: state.isCreatingTrip
                          ? null
                          : () async {
                              final trip = await notifier.submitTrip();
                              if (!context.mounted) return;
                              Navigator.of(context).pushReplacement(
                                trip.inviteCode != null
                                    ? MaterialPageRoute(
                                        builder: (_) => GroupInviteScreen(
                                          tripId: trip.tripId,
                                          inviteCode: trip.inviteCode!,
                                        ),
                                      )
                                    : MaterialPageRoute(builder: (_) => ItineraryScreen(tripId: trip.tripId)),
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
