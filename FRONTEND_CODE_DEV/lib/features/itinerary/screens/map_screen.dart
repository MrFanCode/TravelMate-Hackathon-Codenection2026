import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/airmail_stripe.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../models/itinerary_models.dart';
import '../providers/itinerary_provider.dart';
import '../../group_sync/screens/group_voting_screen.dart';
import '../../budget/screens/budget_overview_screen.dart';
import '../../group_sync/providers/location_provider.dart';
import '../../group_sync/screens/sos_alert_screen.dart';
import '../../group_sync/providers/announcement_provider.dart';
import '../../group_sync/screens/send_announcement_screen.dart';

/// Screen 7 — Map View. Pins/route are drawn locally (stylized, not to
/// real scale) — only suggestion/activity data comes from the API, per
/// solo-itinerary-api-contract.md. Swap in a real Mapbox widget later
/// without touching the data layer.
class MapScreen extends ConsumerStatefulWidget {
  final String tripId;
  const MapScreen({super.key, required this.tripId});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final notifier = ref.read(itineraryProvider);
      if (notifier.trip == null) {
        await notifier.loadTrip(widget.tripId);
      }
      notifier.loadNearby();
      if (notifier.trip?.tripType == 'group') {
        final location = ref.read(locationProvider);
        location.loadMemberLocations(widget.tripId);
        location.checkActiveSos(widget.tripId);
        ref.read(announcementProvider).checkLatest(widget.tripId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(itineraryProvider);
    final locationState = ref.watch(locationProvider);
    final announcementState = ref.watch(announcementProvider);
    final activities = state.currentDay?.activities ?? [];
    final isGroupTrip = state.trip?.tripType == 'group';

    return Scaffold(
      floatingActionButton: !isGroupTrip
          ? null
          : FloatingActionButton.extended(
              backgroundColor: AppColors.rust,
              icon: const Icon(Icons.sos, color: AppColors.cream),
              label: Text('I need help', style: AppTextStyles.buttonLabel),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Alert the group?', style: AppTextStyles.displayMedium.copyWith(fontSize: 18)),
                    content: Text(
                      'This shares your current location with everyone on the trip immediately.',
                      style: AppTextStyles.body,
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Send alert')),
                    ],
                  ),
                );
                if (confirmed != true) return;
                // Mock coordinates — real build reads this from geolocator.
                await ref.read(locationProvider).triggerSos(widget.tripId, 38.7050, -9.1480);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Alert sent to the group.')),
                  );
                }
              },
            ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const AirmailStripe(),
            if (isGroupTrip && locationState.activeSos != null)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.rust,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.priority_high, color: AppColors.cream, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text('${locationState.activeSos!.fromName} needs help', style: AppTextStyles.bodyStrong.copyWith(color: AppColors.cream, fontSize: 12.5)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => SosAlertScreen(tripId: widget.tripId)),
                      ),
                      child: Text('View', style: AppTextStyles.label.copyWith(color: AppColors.cream, fontSize: 10)),
                    ),
                  ],
                ),
              ),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Day ${state.selectedDay} · ${activities.length} stops', style: AppTextStyles.eyebrow),
                      Row(
                        children: [
                          _legendDot(AppColors.rust, false),
                          const SizedBox(width: 4),
                          Text('Your plan', style: AppTextStyles.label.copyWith(fontSize: 9.5)),
                          const SizedBox(width: 10),
                          _legendDot(AppColors.cream, true),
                          const SizedBox(width: 4),
                          Text('Nearby', style: AppTextStyles.label.copyWith(fontSize: 9.5)),
                          if (isGroupTrip) ...[
                            const SizedBox(width: 10),
                            _legendDot(AppColors.mustard, false),
                            const SizedBox(width: 4),
                            Text('Group', style: AppTextStyles.label.copyWith(fontSize: 9.5)),
                          ],
                        ],
                      ),
                    ],
                  ),
                  if (isGroupTrip)
                    Row(
                      children: [
                        Switch(
                          value: locationState.sharingEnabled,
                          activeColor: AppColors.pine,
                          onChanged: (v) => ref.read(locationProvider).toggleSharing(widget.tripId, v),
                        ),
                        Expanded(
                          child: Text(
                            locationState.sharingEnabled ? 'Sharing your location with the group' : 'Share your location with the group',
                            style: AppTextStyles.label.copyWith(fontSize: 9.5),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => SendAnnouncementScreen(tripId: widget.tripId)),
                          ),
                          icon: const Icon(Icons.campaign_outlined, size: 16, color: AppColors.pine),
                          label: Text('Announce', style: AppTextStyles.label.copyWith(fontSize: 9.5, color: AppColors.pine)),
                          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                        ),
                      ],
                    ),
                  if (isGroupTrip && announcementState.latest != null)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                      decoration: BoxDecoration(
                        color: AppColors.pine,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.campaign, color: AppColors.cream, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${announcementState.latest!.fromName}: ${announcementState.latest!.message}',
                              style: AppTextStyles.bodyStrong.copyWith(color: AppColors.cream, fontSize: 11.5),
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () => ref.read(announcementProvider).dismiss(),
                            icon: const Icon(Icons.close, color: AppColors.cream, size: 16),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: AppColors.paper2,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.ink, width: 1.5),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    for (int i = 0; i < activities.length; i++)
                      _pin(
                        left: 20.0 + (i * 55) % 220,
                        top: 20.0 + (i * 70) % 200,
                        label: '${i + 1}',
                        filled: true,
                      ),
                    if (!state.isLoadingNearby)
                      for (int i = 0; i < state.nearby.length; i++)
                        _pin(
                          left: 60.0 + (i * 80) % 200,
                          top: 60.0 + (i * 50) % 180,
                          label: '+',
                          filled: false,
                        ),
                    if (isGroupTrip && !locationState.isLoadingLocations)
                      for (int i = 0; i < locationState.memberLocations.length; i++)
                        _memberPin(
                          left: 100.0 + (i * 65) % 180,
                          top: 130.0 + (i * 40) % 140,
                          initial: locationState.memberLocations[i].initial,
                        ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
                decoration: const BoxDecoration(
                  color: AppColors.cream,
                  border: Border(top: BorderSide(color: AppColors.ink, width: 1.5)),
                ),
                child: ListView(
                  children: [
                    ...activities.map((a) => _sheetRow(a.time, a.title, filled: true)),
                    if (!state.isLoadingNearby)
                      ...state.nearby.map((s) => _sheetRow(
                            s.type == SuggestionType.hotel ? 'hotel' : 'nearby',
                            s.subtitle != null ? '${s.title} · ${s.subtitle}' : s.title,
                            filled: false,
                            onAdd: () => ref.read(itineraryProvider).addFromSuggestion(s),
                          )),
                  ],
                ),
              ),
            ),
            AppBottomNavBar(
              current: MainTab.map,
              onSelect: (tab) {
                if (tab == MainTab.trip) {
                  Navigator.of(context).pop();
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
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendDot(Color color, bool dashed) => Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: dashed ? AppColors.cream : color,
          shape: BoxShape.circle,
          border: dashed ? Border.all(color: AppColors.pine, width: 1.5) : null,
        ),
      );

  Widget _pin({required double left, required double top, required String label, required bool filled}) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: filled ? 26 : 20,
        height: filled ? 26 : 20,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled ? AppColors.rust : AppColors.cream,
          shape: BoxShape.circle,
          border: Border.all(color: filled ? AppColors.inkSoft : AppColors.pine, width: 1.5),
        ),
        child: Text(
          label,
          style: AppTextStyles.label.copyWith(
            fontSize: 10,
            color: filled ? AppColors.cream : AppColors.pine,
          ),
        ),
      ),
    );
  }

  Widget _memberPin({required double left, required double top, required String initial}) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.mustard,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.ink, width: 1.5),
        ),
        child: Text(initial, style: AppTextStyles.label.copyWith(fontSize: 10, color: AppColors.ink)),
      ),
    );
  }

  Widget _sheetRow(String tag, String title, {required bool filled, VoidCallback? onAdd}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: filled ? AppColors.cream : AppColors.cream,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: filled ? AppColors.ink : AppColors.pine,
          width: 1.5,
          style: filled ? BorderStyle.solid : BorderStyle.solid,
        ),
      ),
      child: Row(
        children: [
          Text(tag, style: AppTextStyles.label.copyWith(fontSize: 9)),
          const SizedBox(width: 10),
          Expanded(child: Text(title, style: AppTextStyles.bodyStrong.copyWith(fontSize: 12.5))),
          if (onAdd != null)
            TextButton(
              onPressed: onAdd,
              style: TextButton.styleFrom(
                backgroundColor: AppColors.pine,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                minimumSize: Size.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('+ Add', style: AppTextStyles.label.copyWith(fontSize: 9, color: AppColors.cream)),
            ),
        ],
      ),
    );
  }
}
