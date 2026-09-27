import 'package:get/get.dart';

class TaxSearchModel {
  final int id;
  final String code;
  final String titleAr;
  final String? titleFr;
  final String? bodyAr;
  final String? bodyFr;
  final String? file;
  final int? year;
  final DateTime createdAt;
  final DateTime updatedAt;

  TaxSearchModel({
    required this.id,
    required this.code,
    required this.titleAr,
    this.titleFr,
    this.bodyAr,
    this.bodyFr,
    this.file,
    this.year,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TaxSearchModel.fromJson(Map<String, dynamic> json) {
    return TaxSearchModel(
      id: json['id'],
      code: json['code'] ?? '',
      titleAr: json['title_ar'] ?? '',
      titleFr: json['title_fr'],
      bodyAr: json['preamble'],
      bodyFr: json['preamble_fr'],
      file: json['file'],
      year: json['year'] != null ? int.tryParse(json['year'].toString()) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'title_ar': titleAr,
      'title_fr': titleFr,
      'body_ar': bodyAr,
      'body_fr': bodyFr,
      'file': file,
      'year': year,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get localizedTitle {
    final lang = Get.locale?.languageCode ?? 'ar';
    return lang == 'ar' ? titleAr : (titleFr ?? titleAr);
  }

  String get localizedBody {
    final lang = Get.locale?.languageCode ?? 'ar';
    return lang == 'ar' ? (bodyAr ?? '') : (bodyFr ?? bodyAr ?? '');
  }
}
