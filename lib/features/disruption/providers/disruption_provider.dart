import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/disruption_mock_service.dart';
import '../models/disruption_models.dart';

class DisruptionNotifier extends ChangeNotifier {
  final DisruptionMockService _service = DisruptionMockService();

  Disruption? disruption;
  bool isLoadingDisruption = false;

  ReplanDiff? diff;
  bool isReplanning = false;

  bool isAccepting = false;

  Future<void> loadDisruption(String tripId) async {
    isLoadingDisruption = true;
    notifyListeners();
    disruption = await _service.fetchLatestDisruption(tripId);
    isLoadingDisruption = false;
    notifyListeners();
  }

  Future<void> requestReplan(String tripId) async {
    if (disruption == null) return;
    isReplanning = true;
    notifyListeners();
    diff = await _service.requestReplan(tripId, disruption!.id);
    isReplanning = false;
    notifyListeners();
  }

  Future<void> acceptReplan(String tripId) async {
    if (disruption == null) return;
    isAccepting = true;
    notifyListeners();
    await _service.acceptReplan(tripId, disruption!.id);
    isAccepting = false;
    notifyListeners();
  }
}

final disruptionProvider = ChangeNotifierProvider<DisruptionNotifier>((ref) => DisruptionNotifier());
