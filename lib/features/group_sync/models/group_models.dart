/// Matches group-sync-api-contract.md.
class GroupMember {
  final String id;
  final String name;
  final String initial;
  final bool isYou;
  final bool isActive;

  GroupMember({
    required this.id,
    required this.name,
    required this.initial,
    required this.isYou,
    this.isActive = false,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) => GroupMember(
        id: json['id'],
        name: json['name'],
        initial: json['initial'],
        isYou: json['is_you'] ?? false,
        isActive: json['is_active'] ?? false,
      );
}

class Proposal {
  final String id;
  final String title;
  final int votes;
  final int totalVoters;

  Proposal({required this.id, required this.title, required this.votes, required this.totalVoters});

  factory Proposal.fromJson(Map<String, dynamic> json) => Proposal(
        id: json['id'],
        title: json['title'],
        votes: json['votes'],
        totalVoters: json['total_voters'],
      );

  double get ratio => totalVoters == 0 ? 0 : votes / totalVoters;
}

class CompromisePick {
  final String title;
  final int day;
  final int voterCount;

  CompromisePick({required this.title, required this.day, required this.voterCount});

  factory CompromisePick.fromJson(Map<String, dynamic> json) => CompromisePick(
        title: json['title'],
        day: json['day'],
        voterCount: json['voter_count'],
      );
}

class CompromiseResult {
  final CompromisePick majorityPick;
  final CompromisePick minorityPick;

  CompromiseResult({required this.majorityPick, required this.minorityPick});

  factory CompromiseResult.fromJson(Map<String, dynamic> json) => CompromiseResult(
        majorityPick: CompromisePick.fromJson(json['majority_pick']),
        minorityPick: CompromisePick.fromJson(json['minority_pick']),
      );
}
