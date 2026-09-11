import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/group_mock_service.dart';
import '../models/group_models.dart';

class GroupNotifier extends ChangeNotifier {
  final GroupMockService _service = GroupMockService();

  List<GroupMember> members = [];
  bool isLoadingMembers = false;

  List<Proposal> proposals = [];
  String? yourVote;
  bool isLoadingProposals = false;

  CompromiseResult? compromise;
  bool isLoadingCompromise = false;

  Future<void> loadMembers(String tripId) async {
    isLoadingMembers = true;
    notifyListeners();
    members = await _service.fetchMembers(tripId);
    isLoadingMembers = false;
    notifyListeners();
  }

  Future<void> loadProposals(String tripId, int day) async {
    isLoadingProposals = true;
    notifyListeners();
    final (p, v) = await _service.fetchProposals(tripId, day);
    proposals = p;
    yourVote = v;
    isLoadingProposals = false;
    notifyListeners();
  }

  Future<void> vote(String tripId, int day, String proposalId) async {
    final (p, v) = await _service.vote(tripId, day, proposalId);
    proposals = p;
    yourVote = v;
    notifyListeners();
  }

  Future<void> loadCompromise(String tripId, int day) async {
    isLoadingCompromise = true;
    notifyListeners();
    compromise = await _service.fetchCompromise(tripId, day);
    isLoadingCompromise = false;
    notifyListeners();
  }

  Future<void> applyCompromise(String tripId) async {
    await _service.applyCompromise(tripId);
  }
}

final groupProvider = ChangeNotifierProvider<GroupNotifier>((ref) => GroupNotifier());
