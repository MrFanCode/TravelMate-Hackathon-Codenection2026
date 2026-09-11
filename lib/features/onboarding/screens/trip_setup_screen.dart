import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/airmail_stripe.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/progress_rail.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/mini_suggestion_card.dart';
import 'interest_selection_screen.dart';

/// Screen 2 — Trip Setup: destination, dates, budget, flight/hotel picks.
class TripSetupScreen extends ConsumerStatefulWidget {
  const TripSetupScreen({super.key});

  @override
  ConsumerState<TripSetupScreen> createState() => _TripSetupScreenState();
}

class _TripSetupScreenState extends ConsumerState<TripSetupScreen> {
  final _destinationController = TextEditingController(text: 'Lisbon, Portugal');
  DateTime _depart = DateTime(2026, 10, 14);
  DateTime _return = DateTime(2026, 10, 21);
  double _budget = 750;
  bool _suggestionsLoaded = false;

  static const _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  String _fmt(DateTime d) => '${_monthNames[d.month - 1]} ${d.day}';

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  Future<void> _loadSuggestions() async {
    final notifier = ref.read(onboardingProvider);
    notifier.updateTripBasics(
      destination: _destinationController.text,
      departDate: _depart,
      returnDate: _return,
      budgetUsd: _budget,
    );
    await notifier.loadSuggestions();
    if (mounted) setState(() => _suggestionsLoaded = true);
  }

  Future<void> _pickDate({required bool isDepart}) async {
    final initial = isDepart ? _depart : _return;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.rust, onPrimary: AppColors.cream),
        ),
        child: child!,
      ),
    );
    if (picked == null) return;
    setState(() {
      if (isDepart) {
        _depart = picked;
        if (_return.isBefore(_depart)) _return = _depart.add(const Duration(days: 1));
      } else {
        _return = picked;
      }
    });
    _loadSuggestions();
  }

  @override
  void initState() {
    super.initState();
    // Fetch suggestions once, on first build, matching GET /suggestions/travel.
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadSuggestions());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);

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
                    const ProgressRail(currentStep: 1),
                    const SizedBox(height: 12),
                    Text('Step 1 of 3', style: AppTextStyles.eyebrow),
                    const SizedBox(height: 4),
                    Text('Where and when?', style: AppTextStyles.displayMedium),
                    Text("We'll build the whole trip around this.", style: AppTextStyles.body),
                    const SizedBox(height: 18),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Destination — a real editable field now, not static text.
                            _editableField(
                              label: 'Destination',
                              controller: _destinationController,
                              onSubmitted: (_) => _loadSuggestions(),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: _tappableField(
                                    label: 'Depart',
                                    value: _fmt(_depart),
                                    onTap: () => _pickDate(isDepart: true),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _tappableField(
                                    label: 'Return',
                                    value: _fmt(_return),
                                    onTap: () => _pickDate(isDepart: false),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 32, color: AppColors.line),
                            Text('Total budget', style: AppTextStyles.label),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text('\$${_budget.round()}', style: AppTextStyles.displayMedium.copyWith(fontSize: 30)),
                                const SizedBox(width: 6),
                                Text('≈ \$${(_budget / 7).round()} / day', style: AppTextStyles.body.copyWith(fontSize: 12)),
                              ],
                            ),
                            Slider(
                              value: _budget,
                              min: 200,
                              max: 3000,
                              activeColor: AppColors.rust,
                              inactiveColor: AppColors.line,
                              onChanged: (v) => setState(() => _budget = v),
                              onChangeEnd: (_) => _loadSuggestions(),
                            ),
                            const Divider(height: 24, color: AppColors.line),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Suggested for these dates', style: AppTextStyles.label),
                                Text('optional', style: AppTextStyles.label.copyWith(fontSize: 9.5)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            if (!_suggestionsLoaded || state.isLoadingSuggestions)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Center(child: CircularProgressIndicator(color: AppColors.rust)),
                              )
                            else ...[
                              ...state.suggestions!.flights.map((f) => MiniSuggestionCard(
                                    icon: Icons.flight_takeoff,
                                    title: '${f.flightNumber} · direct',
                                    subtitle: '\$${f.priceUsd.round()} round trip',
                                    picked: state.data.selectedFlightId == f.id,
                                    onTap: () => ref.read(onboardingProvider).pickFlight(
                                          state.data.selectedFlightId == f.id ? null : f.id,
                                        ),
                                  )),
                              ...state.suggestions!.hotels.map((h) => MiniSuggestionCard(
                                    icon: Icons.hotel,
                                    title: h.name,
                                    subtitle: '${h.distanceFromCenterMi}mi from center · \$${h.pricePerNightUsd.round()}/night',
                                    picked: state.data.selectedHotelId == h.id,
                                    onTap: () => ref.read(onboardingProvider).pickHotel(
                                          state.data.selectedHotelId == h.id ? null : h.id,
                                        ),
                                  )),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    PrimaryButton(
                      label: 'Continue',
                      onPressed: () {
                        _loadSuggestions(); // make sure typed destination is saved even without pressing enter
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const InterestSelectionScreen()),
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

  Widget _editableField({
    required String label,
    required TextEditingController controller,
    ValueChanged<String>? onSubmitted,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.ink, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(label, style: AppTextStyles.label.copyWith(fontSize: 10)),
          ),
          TextField(
            controller: controller,
            style: AppTextStyles.bodyStrong.copyWith(fontSize: 16),
            onSubmitted: onSubmitted,
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tappableField({required String label, required String value, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.ink, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.label.copyWith(fontSize: 10)),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value, style: AppTextStyles.bodyStrong.copyWith(fontSize: 16)),
                const Icon(Icons.calendar_today, size: 14, color: AppColors.inkSoft),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
