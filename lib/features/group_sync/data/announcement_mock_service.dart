import '../models/announcement_models.dart';

/// Stands in for the backend. Shapes match announcement-api-contract.md.
class AnnouncementMockService {
  Announcement? _latest;

  Future<Announcement> send(String tripId, String message) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _latest = Announcement(
      announcementId: 'ann_${DateTime.now().millisecondsSinceEpoch}',
      fromUserId: 'u_01',
      fromName: 'You',
      message: message,
    );
    return _latest!;
  }

  Future<Announcement?> fetchLatest(String tripId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _latest;
  }
}
