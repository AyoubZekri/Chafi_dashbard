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
  final String? isTaxpayer; // المكلف بالضريبة (نوع أو وصف)
  final bool? isRegisteredTaxAdmin; // مسجل في الإدارة الجبائية
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
    this.isTaxpayer,
    this.isRegisteredTaxAdmin,
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
      isTaxpayer: json['is_taxpayer']?.toString(),
      isRegisteredTaxAdmin: json['is_registered_tax_admin'] == null
          ? null
          : json['is_registered_tax_admin'] == true ||
              json['is_registered_tax_admin'].toString() == '1',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  static List<UserModel> fromList(List<dynamic> list) {
    return list.map((e) => UserModel.fromJson(e)).toList();
  }
}

class UserFeedback {
  final String date;
  final List<int> types;

  UserFeedback({
    required this.date,
    required this.types,
  });

  factory UserFeedback.fromJson(Map<String, dynamic> json) {
    return UserFeedback(
      date: json['date'] ?? '',
      types: json['types'] != null ? List<int>.from(json['types']) : [],
    );
  }
}
