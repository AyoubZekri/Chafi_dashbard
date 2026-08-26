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
  final String readTime;
  final String chafiAdvice;
  final String chafiAdviceFr;
  final String legalSource;
  final String legalSourceFr;
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
    required this.readTime,
    required this.chafiAdvice,
    required this.chafiAdviceFr,
    required this.legalSource,
    required this.legalSourceFr,
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
      readTime: json['read_time']?.toString() ?? "",
      chafiAdvice: json['chafi_advice']?.toString() ?? "",
      chafiAdviceFr: json['chafi_advice_fr']?.toString() ?? "",
      legalSource: json['legal_source']?.toString() ?? "",
      legalSourceFr: json['legal_source_fr']?.toString() ?? "",
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
      'read_time': readTime,
      'chafi_advice': chafiAdvice,
      'chafi_advice_fr': chafiAdviceFr,
      'legal_source': legalSource,
      'legal_source_fr': legalSourceFr,
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

  String get localizedChafiAdvice {
    final lang = Get.locale?.languageCode ?? 'ar';
    return lang == 'ar' ? chafiAdvice : chafiAdviceFr;
  }

  String get localizedLegalSource {
    final lang = Get.locale?.languageCode ?? 'ar';
    return lang == 'ar' ? legalSource : legalSourceFr;
  }
}
