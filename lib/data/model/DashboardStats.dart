class DashboardStats {
  final int totalUsersEnter;
  final int totalGuestsEnter;
  final int totalUsersEntertoday;
  final int totalGuestsEntertoday;
  final int user;
  final int tax1Jazafi;
  final int tax2Mobassat;
  final int tax3Hakiki;

  DashboardStats({
    required this.totalUsersEnter,
    required this.totalGuestsEnter,
    required this.totalUsersEntertoday,
    required this.totalGuestsEntertoday,
    required this.user,
    required this.tax1Jazafi,
    required this.tax2Mobassat,
    required this.tax3Hakiki,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalUsersEnter: int.parse(json['totalUsersEnter'].toString()),
      totalGuestsEnter: int.parse(json['totalGuestsEnter'].toString()),
      totalUsersEntertoday: int.parse(json['totalUsersEntertoday'].toString()),
      totalGuestsEntertoday: int.parse(json['totalGuestsEntertoday'].toString()),
      user: json['user'] ?? 0,
      tax1Jazafi: json['tax_1_jazafi'] ?? 0,
      tax2Mobassat: json['tax_2_mobassat'] ?? 0,
      tax3Hakiki: json['tax_3_hakiki'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "totalUsersEnter": totalUsersEnter,
      "totalGuestsEnter": totalGuestsEnter,
      "totalUsersEntertoday": totalUsersEntertoday,
      "totalGuestsEntertoday": totalGuestsEntertoday,
      "user": user,
      "tax_1_jazafi": tax1Jazafi,
      "tax_2_mobassat": tax2Mobassat,
      "tax_3_hakiki": tax3Hakiki,
    };
  }
}