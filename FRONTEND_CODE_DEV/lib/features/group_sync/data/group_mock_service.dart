import '../models/group_models.dart';

/// Stands in for the backend. Shapes match group-sync-api-contract.md.
/// _joinedCount grows on repeated calls to simulate people joining via
/// the invite link, so the UI has something to visibly update.
class GroupMockService {
  int _joinedCount = 1;

  Future<List<GroupMember>> fetchMembers(String tripId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final all = [
      GroupMember(id: 'u_01', name: 'Maya', initial: 'M', isYou: true, isActive: true),
      GroupMember(id: 'u_02', name: 'Jake', initial: 'J', isYou: false, isActive: true),
      GroupMember(id: 'u_03', name: 'Rosa', initial: 'R', isYou: false, isActive: false),
    ];
    if (_joinedCount < all.length) _joinedCount++;
    return all.sublist(0, _joinedCount);
  }

  final List<Proposal> _proposals = [
    Proposal(id: 'prop_01', title: 'Sintra day trip', votes: 3, totalVoters: 4),
    Proposal(id: 'prop_02', title: 'Beach day — Cascais', votes: 1, totalVoters: 4),
    Proposal(id: 'prop_03', title: 'Free exploring', votes: 2, totalVoters: 4),
  ];
  String? _yourVote = 'prop_01';

  Future<(List<Proposal>, String?)> fetchProposals(String tripId, int day) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return (_proposals, _yourVote);
  }

  Future<(List<Proposal>, String?)> vote(String tripId, int day, String proposalId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    if (_yourVote != null) {
      final prev = _proposals.indexWhere((p) => p.id == _yourVote);
      if (prev != -1) {
        _proposals[prev] = Proposal(
          id: _proposals[prev].id,
          title: _proposals[prev].title,
          votes: _proposals[prev].votes - 1,
          totalVoters: _proposals[prev].totalVoters,
        );
      }
    }
    final i = _proposals.indexWhere((p) => p.id == proposalId);
    _proposals[i] = Proposal(
      id: _proposals[i].id,
      title: _proposals[i].title,
      votes: _proposals[i].votes + 1,
      totalVoters: _proposals[i].totalVoters,
    );
    _yourVote = proposalId;
    return (_proposals, _yourVote);
  }

  Future<CompromiseResult> fetchCompromise(String tripId, int day) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return CompromiseResult(
      majorityPick: CompromisePick(title: 'Sintra day trip', day: 3, voterCount: 3),
      minorityPick: CompromisePick(title: 'Cascais beach afternoon', day: 5, voterCount: 1),
    );
  }

  Future<void> applyCompromise(String tripId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // mock — real backend returns the updated itinerary days array
  }
}
