import '../models/location_models.dart';

/// Stands in for the backend. Shapes match group-location-api-contract.md.
///
/// PRODUCTION NOTE: real location updates should come from a device GPS
/// stream (the `geolocator` package) sent periodically, and locations
/// should arrive via a Firestore realtime listener, not polling. This
/// mock just returns fixed points so the UI can be built now.
class LocationMockService {
  bool _sharingEnabled = false;

  Future<void> setSharing(bool enabled) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _sharingEnabled = enabled;
  }

  bool get sharingEnabled => _sharingEnabled;

  Future<List<MemberLocation>> fetchMemberLocations(String tripId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      MemberLocation(userId: 'u_02', name: 'Jake', initial: 'J', lat: 38.7108, lng: -9.1421),
      MemberLocation(userId: 'u_03', name: 'Rosa', initial: 'R', lat: 38.7135, lng: -9.1290),
    ];
  }

  SosAlert? _activeSos;

  Future<SosAlert> triggerSos(String tripId, double lat, double lng) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _activeSos = SosAlert(sosId: 'sos_01', fromUserId: 'u_01', fromName: 'You', lat: lat, lng: lng);
    return _activeSos!;
  }

  Future<SosAlert?> fetchLatestSos(String tripId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _activeSos;
  }

  Future<void> resolveSos(String tripId, String sosId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _activeSos = null;
  }
}
