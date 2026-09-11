import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/location_mock_service.dart';
import '../models/location_models.dart';

class LocationNotifier extends ChangeNotifier {
  final LocationMockService _service = LocationMockService();

  bool sharingEnabled = false;
  List<MemberLocation> memberLocations = [];
  bool isLoadingLocations = false;

  SosAlert? activeSos;

  Future<void> toggleSharing(String tripId, bool enabled) async {
    await _service.setSharing(enabled);
    sharingEnabled = enabled;
    notifyListeners();
  }

  Future<void> loadMemberLocations(String tripId) async {
    isLoadingLocations = true;
    notifyListeners();
    memberLocations = await _service.fetchMemberLocations(tripId);
    isLoadingLocations = false;
    notifyListeners();
  }

  Future<void> triggerSos(String tripId, double lat, double lng) async {
    activeSos = await _service.triggerSos(tripId, lat, lng);
    notifyListeners();
  }

  Future<void> checkActiveSos(String tripId) async {
    activeSos = await _service.fetchLatestSos(tripId);
    notifyListeners();
  }

  Future<void> resolveSos(String tripId) async {
    if (activeSos == null) return;
    await _service.resolveSos(tripId, activeSos!.sosId);
    activeSos = null;
    notifyListeners();
  }
}

final locationProvider = ChangeNotifierProvider<LocationNotifier>((ref) => LocationNotifier());
