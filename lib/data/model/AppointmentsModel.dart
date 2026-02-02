import 'package:get/get.dart';

class Appointmentsmodel {
  final int id;
  final int index;
  final int taxId;

  final String declarationAr;
  final String declarationFr;

  final String deadline;
  final String noticeDate;

  final String dependenciesAr;
  final String dependenciesFr;

  final DateTime createdAt;
  final DateTime updatedAt;

  Appointmentsmodel({
    required this.id,
    required this.index,
    required this.taxId,
    required this.declarationAr,
    required this.declarationFr,
    required this.deadline,
    required this.dependenciesAr,
    required this.dependenciesFr,
    required this.createdAt,
    required this.updatedAt,
    required this.noticeDate,
  });

  String get declaration {
    return Get.locale?.languageCode == 'fr' ? declarationFr : declarationAr;
  }

  String get dependencies {
    return Get.locale?.languageCode == 'fr' ? dependenciesFr : dependenciesAr;
  }

  factory Appointmentsmodel.fromJson(Map<String, dynamic> json) {
    return Appointmentsmodel(
      id: json['id'],
      index: json['index'],
      taxId: json['tax_id'],
      declarationAr: json['declaration'] ?? '',
      declarationFr: json['declaration_fr'] ?? '',
      deadline: json['deadline'] ?? "",
      noticeDate: json['noticeDate'] ?? "",

      dependenciesAr: json['dependencies'],
      dependenciesFr: json['dependencies_fr'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
