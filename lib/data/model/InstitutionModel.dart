class InstitutionModel {
  final int id;
  final int typeInstitution;
  final int scope;
  final int index;
  final String title;
  final String body;
  final String titleFr;
  final String bodyFr;
  final int? lawId;
  final String? indexLink;
  final String? calcul;
  final DateTime createdAt;
  final DateTime updatedAt;

  InstitutionModel({
    required this.id,
    required this.typeInstitution,
    required this.scope,
    required this.index,
    required this.title,
    required this.body,
    required this.titleFr,
    required this.bodyFr,
    this.lawId,
    this.indexLink,
    this.calcul,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InstitutionModel.fromJson(Map<String, dynamic> json) {
    return InstitutionModel(
      id: json['id'],
      typeInstitution: json['type_institution'],
      scope: json['scope'],
      index: json['index'],
      title: json['title'],
      body: json['body'],
      titleFr: json['title_fr'],
      bodyFr: json['body_fr'],
      lawId: json['law_id'],
      indexLink: json['index_link'],
      calcul: json['calcul'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type_institution': typeInstitution,
      'scope': scope,
      'index': index,
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
}
