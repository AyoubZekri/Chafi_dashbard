import 'package:get/get.dart';

class NotificationModel {
  final int id;
  final String title;
  final String content;
  final String titleFr;
  final String contentFr;
  final int typeNotification;
  final int? taxId;
  final String timer;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.content,
    required this.titleFr,
    required this.contentFr,
    required this.typeNotification,
    this.taxId,
    required this.timer,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      titleFr: json['title_fr'] ?? '',
      contentFr: json['content_fr'] ?? '',
      typeNotification: json['type_notification'],
      taxId: json['tax_id'],
      timer: json['timer'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'title_fr': titleFr,
      'content_fr': contentFr,
      'type_notification': typeNotification,
      'tax_id': taxId,
      'timer': timer,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get localizedtitle {
    final lang = Get.locale?.languageCode ?? 'ar';
    return lang == 'ar' ? title : titleFr;
  }

  String get localizedcontent {
    final lang = Get.locale?.languageCode ?? 'ar';
    return lang == 'ar' ? content : contentFr;
  }
}
