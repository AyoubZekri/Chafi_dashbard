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
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  static List<UserModel> fromList(List<dynamic> list) {
    return list.map((e) => UserModel.fromJson(e)).toList();
  }
}
