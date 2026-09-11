/// Matches group-location-api-contract.md.
class MemberLocation {
  final String userId;
  final String name;
  final String initial;
  final double lat;
  final double lng;

  MemberLocation({
    required this.userId,
    required this.name,
    required this.initial,
    required this.lat,
    required this.lng,
  });

  factory MemberLocation.fromJson(Map<String, dynamic> json) => MemberLocation(
        userId: json['user_id'],
        name: json['name'],
        initial: json['initial'],
        lat: (json['lat'] as num).toDouble(),
        lng: (json['lng'] as num).toDouble(),
      );
}

class SosAlert {
  final String sosId;
  final String fromUserId;
  final String fromName;
  final double lat;
  final double lng;

  SosAlert({
    required this.sosId,
    required this.fromUserId,
    required this.fromName,
    required this.lat,
    required this.lng,
  });

  factory SosAlert.fromJson(Map<String, dynamic> json) => SosAlert(
        sosId: json['sos_id'],
        fromUserId: json['from_user_id'],
        fromName: json['from_name'],
        lat: (json['lat'] as num).toDouble(),
        lng: (json['lng'] as num).toDouble(),
      );
}
