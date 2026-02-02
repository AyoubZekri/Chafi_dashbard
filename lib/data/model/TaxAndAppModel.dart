import 'package:get/get.dart';

class Taxandappmodel {
  final int id;
  final int index;
  final int catId;
  final String title;
  final String body;
  final String titleFr;
  final String bodyFr;
  final int? lawId;
  final String indexLink;
  final String? calcul;
  final DateTime createdAt;
  final DateTime updatedAt;

  Taxandappmodel({
    required this.id,
    required this.index,
    required this.catId,
    required this.title,
    required this.body,
    required this.titleFr,
    required this.bodyFr,
    this.lawId,
    required this.indexLink,
    this.calcul,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Taxandappmodel.fromJson(Map<String, dynamic> json) {
    return Taxandappmodel(
      id: json['id'],
      index: json['index'],
      catId: json['cat_id'],
      title: json['title'],
      body: json['body'],
      titleFr: json['title_fr'],
      bodyFr: json['body_fr'],
      lawId: json['law_id'],
      indexLink: json['index_link']?? "",
      calcul: json['calcul'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'index': index,
      'cat_id': catId,
      'title': title,
      'body': body,
      'title_fr': titleFr,
      'body_fr': bodyFr,
      'law_id': lawId,
      'index_link': indexLink,
      'calcul': calcul,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get localizedTitle {
    final lang = Get.locale?.languageCode ?? 'ar';
    return lang == 'ar' ? title : titleFr;
  }

  String get localizedBody {
    final lang = Get.locale?.languageCode ?? 'ar';
    return lang == 'ar' ? body : bodyFr;
  }

}
