import 'package:get/get.dart';

class ActivityModel {
  final int id;
  final int index;
  final int nataireActivitysId;
  final String name;
  final String nameFr;
  final String body;
  final String bodyFr;
  final int taxId;
  final int statusTax;
  final int codeActivity;
  final String natairenamefr;
  final String natairename;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  ActivityModel({
    required this.id,
    required this.index,
    required this.nataireActivitysId,
    required this.name,
    required this.nameFr,
    required this.body,
    required this.bodyFr,
    required this.taxId,
    required this.statusTax,
    required this.codeActivity,
    this.createdAt,
    this.updatedAt,
    required this.natairenamefr,
    required this.natairename,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'],
      index: json['index'],
      nataireActivitysId: json['nataire_activitys_id'],
      name: json['name'] ?? '',
      nameFr: json['name_fr'] ?? '',
      body: json['body'] ?? '',
      bodyFr: json['body_fr'] ?? '',
      taxId: json['tax_id'],
      statusTax: json['status_tax'],
      codeActivity: json['code_activity'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      natairenamefr: json['nataire_name_fr'],
      natairename: json['nataire_name'],
    );
  }

  String get localizedName {
    final lang = Get.locale?.languageCode ?? 'ar';
    return lang == 'ar' ? name : nameFr;
  }

  String get localizedBody {
    final lang = Get.locale?.languageCode ?? 'ar';
    return lang == 'ar' ? body : bodyFr;
  }

    String get  nataireName {
    final lang = Get.locale?.languageCode ?? 'ar';
    return lang == 'ar' ? natairename : natairenamefr;
  }
}
