import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/announcement_mock_service.dart';
import '../models/announcement_models.dart';

class AnnouncementNotifier extends ChangeNotifier {
  final AnnouncementMockService _service = AnnouncementMockService();

  Announcement? latest;
  bool isSending = false;

  Future<void> send(String tripId, String message) async {
    isSending = true;
    notifyListeners();
    latest = await _service.send(tripId, message);
    isSending = false;
    notifyListeners();
  }

  Future<void> checkLatest(String tripId) async {
    latest = await _service.fetchLatest(tripId);
    notifyListeners();
  }

  void dismiss() {
    latest = null;
    notifyListeners();
  }
}

final announcementProvider = ChangeNotifierProvider<AnnouncementNotifier>((ref) => AnnouncementNotifier());
