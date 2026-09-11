import '../models/disruption_models.dart';

/// Stands in for the backend. Shapes match disruption-api-contract.md.
///
/// IMPORTANT: unlike the other mock services, this one doesn't wait for a
/// user action to "create" a disruption — a disruption is assumed to
/// already exist by the time this screen opens, same as it would in
/// production (a push notification, not a button, opens this screen).
class DisruptionMockService {
  Future<Disruption> fetchLatestDisruption(String tripId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Disruption(
      id: 'dis_01',
      type: 'flight_delay',
      title: 'Flight TP1358 delayed',
      description: 'Now landing 6:40 PM instead of 3:20 PM — this affects your Day 1 plan.',
      affectedDay: 1,
      affectedActivities: [
        AffectedActivity(id: 'act_02', title: 'Belém Tower & riverside walk', reason: 'Closes 6:00 PM — will be missed'),
        AffectedActivity(id: 'act_05', title: 'Fado dinner show', reason: 'Booking may need to shift later'),
      ],
    );
  }

  Future<ReplanDiff> requestReplan(String tripId, String disruptionId) async {
    await Future.delayed(const Duration(milliseconds: 600)); // pretend OR-Tools + Ollama are working
    return ReplanDiff(
      day: 1,
      removed: [DiffItem(id: 'act_02', time: '10:00 AM', title: 'Belém Tower walk')],
      added: [
        DiffItem(id: 'act_06', time: '7:15 PM', title: 'Riverside sunset stroll'),
        DiffItem(id: 'act_07', time: '8:30 PM', title: 'Late fado dinner (rebooked)'),
      ],
      unchangedNote: 'Day 2 unaffected',
    );
  }

  Future<void> acceptReplan(String tripId, String disruptionId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // mock — real backend returns the updated ItineraryDay, matching
    // solo-itinerary-api-contract.md, and writes it to Firestore
  }
}
