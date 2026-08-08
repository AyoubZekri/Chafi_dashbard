import 'package:get/get.dart';

class AppointmentDateModel {
  final int id;
  final int appointmentId;
  final String appointmentDate;
  final String alertDate;

  AppointmentDateModel({
    required this.id,
    required this.appointmentId,
    required this.appointmentDate,
    required this.alertDate,
  });

  factory AppointmentDateModel.fromJson(Map<String, dynamic> json) {
    return AppointmentDateModel(
      id: json['id'],
      appointmentId: json['appointment_id'],
      appointmentDate: json['appointment_date'] ?? '',
      alertDate: json['alert_date'] ?? '',
    );
  }
}

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
  final List<AppointmentDateModel> appointmentDates;

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
    required this.appointmentDates,
  });

  String get declaration {
    return Get.locale?.languageCode == 'fr' ? declarationFr : declarationAr;
  }

  String get dependencies {
    return Get.locale?.languageCode == 'fr' ? dependenciesFr : dependenciesAr;
  }

  factory Appointmentsmodel.fromJson(Map<String, dynamic> json) {
    var list = json['appointment_dates'] as List? ?? [];
    List<AppointmentDateModel> datesList = list.map((i) => AppointmentDateModel.fromJson(i)).toList();

    return Appointmentsmodel(
      id: json['id'],
      index: json['index'],
      taxId: json['tax_id'],
      declarationAr: json['declaration'] ?? '',
      declarationFr: json['declaration_fr'] ?? '',
      deadline: json['deadline'] ?? "",
      noticeDate: json['noticeDate'] ?? "",
      dependenciesAr: json['dependencies'] ?? '',
      dependenciesFr: json['dependencies_fr'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      appointmentDates: datesList,
    );
  }
}
