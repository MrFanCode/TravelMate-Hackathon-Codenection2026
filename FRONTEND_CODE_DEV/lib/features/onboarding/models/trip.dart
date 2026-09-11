/// Matches the response of POST /trips in onboarding-api-contract.md.
/// This is what Screen 5 (AI itinerary output — not built yet) will
/// eventually render. Kept here now so the shape is agreed in advance.
class TripActivity {
  final String id;
  final String time;
  final String title;
  final int durationMin;
  final double costUsd;

  TripActivity({
    required this.id,
    required this.time,
    required this.title,
    required this.durationMin,
    required this.costUsd,
  });

  factory TripActivity.fromJson(Map<String, dynamic> json) => TripActivity(
        id: json['id'],
        time: json['time'],
        title: json['title'],
        durationMin: json['duration_min'],
        costUsd: (json['cost_usd'] as num).toDouble(),
      );
}

class TripDay {
  final int day;
  final String date;
  final List<TripActivity> activities;

  TripDay({required this.day, required this.date, required this.activities});

  factory TripDay.fromJson(Map<String, dynamic> json) => TripDay(
        day: json['day'],
        date: json['date'],
        activities: (json['activities'] as List)
            .map((a) => TripActivity.fromJson(a))
            .toList(),
      );
}

class Trip {
  final String tripId;
  final String destination;
  final String tripType;
  final List<TripDay> days;
  final String? inviteCode; // present only when tripType == 'group'

  Trip({
    required this.tripId,
    required this.destination,
    required this.tripType,
    required this.days,
    this.inviteCode,
  });

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        tripId: json['trip_id'],
        destination: json['destination'],
        tripType: json['trip_type'],
        days: (json['days'] as List).map((d) => TripDay.fromJson(d)).toList(),
        inviteCode: json['invite_code'],
      );
}
