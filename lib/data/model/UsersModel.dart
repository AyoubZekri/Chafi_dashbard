class UserModel {
  final int id;
  final String username;
  final String role;
  final String wilaya;
  final String numperPhone;
  final String email;
  final String? image;
  final String? gmailId;
  final int notificationStatus;
  final int? statsCount;
  final List<UserFeedback>? feedback;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.username,
    required this.role,
    required this.wilaya,
    required this.numperPhone,
    required this.email,
    this.image,
    this.gmailId,
    required this.notificationStatus,
    this.statsCount,
    this.feedback,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      role: json['role'],
      wilaya: json['wilaya'],
      numperPhone: json['numperPhone'].toString(),
      email: json['email'],
      image: json['image'],
      gmailId: json['gmail_id'],
      notificationStatus: json['notification_status'],
      statsCount: json['stats_count'],
      feedback: json['feedback'] != null
          ? (json['feedback'] as List)
              .map((e) => UserFeedback.fromJson(e))
              .toList()
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  static List<UserModel> fromList(List<dynamic> list) {
    return list.map((e) => UserModel.fromJson(e)).toList();
  }
}

class UserFeedback {
  final int id;
  final int userId;
  final int type;
  final DateTime createdAt;

  UserFeedback({
    required this.id,
    required this.userId,
    required this.type,
    required this.createdAt,
  });

  factory UserFeedback.fromJson(Map<String, dynamic> json) {
    return UserFeedback(
      id: json['id'],
      userId: json['user_id'],
      type: json['type'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
