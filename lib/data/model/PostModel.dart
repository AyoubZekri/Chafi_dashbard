import 'package:get/get.dart';

class PostModel {
  final int id;
  final String? image;
  final int type;
  final String title;
  final String title2;
  final String body;
  final String titleFr;
  final String title2Fr;
  final String bodyFr;
  final DateTime createdAt;
  final DateTime updatedAt;

  PostModel({
    required this.id,
    this.image,
    required this.type,
    required this.title,
    required this.title2,
    required this.body,
    required this.titleFr,
    required this.title2Fr,
    required this.bodyFr,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      image: json['image'],
      type: json['type'],
      title: json['title']??"",
      title2: json['title2']?? "",
      body: json['body']?? "",
      titleFr: json['title_fr']??"",
      title2Fr: json['title2_fr']??"",
      bodyFr: json['body_fr']??"",
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'type': type,
      'title': title,
      'title2': title2,
      'body': body,
      'title_fr': titleFr,
      'title2_fr': title2Fr,
      'body_fr': bodyFr,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get localizedTitle {
    final lang = Get.locale?.languageCode ?? 'ar';
    return lang == 'ar' ? title : titleFr;
  }

  String get localizedTitle2 {
    final lang = Get.locale?.languageCode ?? 'ar';
    return lang == 'ar' ? title2 : title2Fr;
  }

  String get localizedBody {
    final lang = Get.locale?.languageCode ?? 'ar';
    return lang == 'ar' ? body : bodyFr;
  }
}
