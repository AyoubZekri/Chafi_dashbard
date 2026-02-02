import 'package:get/get.dart';

class LawModel {
  int id;
  String name;
  String nameFr;
  int index;
  String publishedDate;
  String? pdf;
  DateTime createdAt;
  DateTime updatedAt;

  LawModel({
    required this.id,
    required this.name,
    required this.nameFr,
    required this.index,
    required this.publishedDate,
    this.pdf,
    required this.createdAt,
    required this.updatedAt,
  });

  // تحويل من JSON لكائن
  factory LawModel.fromJson(Map<String, dynamic> json) {
    return LawModel(
      id: json['id'],
      name: json['name'] ?? '',
      nameFr: json['name_fr'] ?? '',
      index: json['index'] ?? 0,
      publishedDate: json['published_date'] ?? '',
      pdf: json['pdf'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_fr': nameFr,
      'index': index,
      'published_date': publishedDate,
      'pdf': pdf,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
    String get localizedName {
    final lang = Get.locale?.languageCode ?? 'ar';
    return lang == 'ar' ? name : nameFr;
  }
}

class LawList {
  List<LawModel> data;

  LawList({required this.data});

  factory LawList.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<LawModel> lawsList = list.map((i) => LawModel.fromJson(i)).toList();
    return LawList(data: lawsList);
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}
