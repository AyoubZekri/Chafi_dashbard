import 'package:get/get.dart';

class Natureoftheactivitymodel {
  final int id;
  final int index;
  final String name;
  final String nameFr;
  final DateTime createdAt;
  final DateTime updatedAt;

  Natureoftheactivitymodel({
    required this.id,
    required this.index,
    required this.name,
    required this.nameFr,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Natureoftheactivitymodel.fromJson(Map<String, dynamic> json) {
    return Natureoftheactivitymodel(
      id: json['id'],
      index: json['index'],
      name: json['name'],
      nameFr: json['name_fr'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'index': index,
      'name': name,
      'name_fr': nameFr,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get localizedName {
    final lang = Get.locale?.languageCode ?? 'ar';
    return lang == 'ar' ? name : nameFr;
  }
}
