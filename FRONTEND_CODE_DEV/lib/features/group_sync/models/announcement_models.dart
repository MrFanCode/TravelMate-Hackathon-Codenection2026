/// Matches announcement-api-contract.md.
class Announcement {
  final String announcementId;
  final String fromUserId;
  final String fromName;
  final String message;

  Announcement({
    required this.announcementId,
    required this.fromUserId,
    required this.fromName,
    required this.message,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
        announcementId: json['announcement_id'],
        fromUserId: json['from_user_id'],
        fromName: json['from_name'],
        message: json['message'],
      );
}
