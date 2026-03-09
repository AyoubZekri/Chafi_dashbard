import 'package:get/get.dart';

class BonusModel {
  final int id;
  final String nameAr;
  final String nameFr;
  final int category;
  final bool isRequired;
  final String? type;
  final bool? hasSpecialLogic;

  BonusModel({
    required this.id,
    required this.nameAr,
    required this.nameFr,
    required this.category,
    required this.isRequired,
    this.type,
    this.hasSpecialLogic,
  });

  factory BonusModel.fromJson(Map<String, dynamic> json) {
    return BonusModel(
      id: json['id'],
      nameAr: json['name_ar'],
      nameFr: json['name_fr'],
      category: json['category'],
      isRequired: json['is_required'] == 1,
      type: json['type'],
      hasSpecialLogic: json['has_special_logic'] != null
          ? json['has_special_logic'] == 1
          : null,
    );
  }

  String get localizedName {
    final lang = Get.locale?.languageCode ?? 'ar';
    return lang == 'ar' ? nameAr : nameFr;
  }
}
