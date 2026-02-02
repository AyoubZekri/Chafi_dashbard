import 'package:get/get.dart';

class DifferentsModel {
  final int id;
  final int index;
  final int type;
  final String title;
  final String body;
  final String titleFr;
  final String bodyFr;
  final int? lawId;
  final String indexLink;
  final String? calcul;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;

  DifferentsModel({
    required this.id,
    required this.index,
    required this.type,
    required this.title,
    required this.body,
    required this.titleFr,
    required this.bodyFr,
    this.lawId,
    required this.indexLink,
    this.calcul,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DifferentsModel.fromJson(Map<String, dynamic> json) {
    return DifferentsModel(
      id: json['id'],
      index: json['index'],
      type: json['type'],
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      titleFr: json['title_fr'] ?? '',
      bodyFr: json['body_fr'] ?? '',
      lawId: json['law_id'],
      indexLink: json['index_link'].toString(),
      calcul: json['calcul'],
      isRead: json['is_read'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
  String get localizedName {
    final lang = Get.locale?.languageCode ?? 'ar';
    return lang == 'ar' ? title : titleFr;
  }

  String get localizedBody {
    final lang = Get.locale?.languageCode ?? 'ar';
    return lang == 'ar' ? body : bodyFr;
  }
}
