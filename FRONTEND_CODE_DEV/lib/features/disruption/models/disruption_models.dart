/// Matches disruption-api-contract.md.
class AffectedActivity {
  final String id;
  final String title;
  final String reason;

  AffectedActivity({required this.id, required this.title, required this.reason});

  factory AffectedActivity.fromJson(Map<String, dynamic> json) => AffectedActivity(
        id: json['id'],
        title: json['title'],
        reason: json['reason'],
      );
}

class Disruption {
  final String id;
  final String type; // 'flight_delay' | 'weather'
  final String title;
  final String description;
  final int affectedDay;
  final List<AffectedActivity> affectedActivities;

  Disruption({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.affectedDay,
    required this.affectedActivities,
  });

  factory Disruption.fromJson(Map<String, dynamic> json) => Disruption(
        id: json['id'],
        type: json['type'],
        title: json['title'],
        description: json['description'],
        affectedDay: json['affected_day'],
        affectedActivities:
            (json['affected_activities'] as List).map((a) => AffectedActivity.fromJson(a)).toList(),
      );
}

class DiffItem {
  final String id;
  final String time;
  final String title;

  DiffItem({required this.id, required this.time, required this.title});

  factory DiffItem.fromJson(Map<String, dynamic> json) => DiffItem(
        id: json['id'],
        time: json['time'],
        title: json['title'],
      );
}

class ReplanDiff {
  final int day;
  final List<DiffItem> removed;
  final List<DiffItem> added;
  final String unchangedNote;

  ReplanDiff({required this.day, required this.removed, required this.added, required this.unchangedNote});

  factory ReplanDiff.fromJson(Map<String, dynamic> json) => ReplanDiff(
        day: json['day'],
        removed: (json['removed'] as List).map((d) => DiffItem.fromJson(d)).toList(),
        added: (json['added'] as List).map((d) => DiffItem.fromJson(d)).toList(),
        unchangedNote: json['unchanged_note'],
      );
}
