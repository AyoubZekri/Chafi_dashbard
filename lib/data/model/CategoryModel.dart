import 'package:get/get.dart';

class CategoryModel {
  final int id;
  final int index;
  final String name;
  final String nameFr;
  final int taxId;
  final int typeCat;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CategoryModel({
    required this.id,
    required this.index,
    required this.name,
    required this.nameFr,
    required this.taxId,
    required this.typeCat,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      index: json['index'],
      name: json['name'] ?? '',
      nameFr: json['name_fr'] ?? '',
      taxId: json['tax_id'] ?? 0,
      typeCat: json['type_cat'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'index': index,
      'name': name,
      'name_fr': nameFr,
      'tax_id': taxId,
      'type_cat': typeCat,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String get localizedName {
    final lang = Get.locale?.languageCode ?? 'ar';
    return lang == 'ar' ? name : nameFr;
  }
}
