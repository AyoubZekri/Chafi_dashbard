class DashboardStats {
  final int totalUsersEnter;
  final int totalGuestsEnter;
  final int totalUsersEntertoday;
  final int totalGuestsEntertoday;
  final int user;
  final int tax1Jazafi;
  final int tax2Mobassat;
  final int tax3Hakiki;
  final double tax1;
  final double tax2;
  final double tax3;

  DashboardStats({
    required this.totalUsersEnter,
    required this.totalGuestsEnter,
    required this.totalUsersEntertoday,
    required this.totalGuestsEntertoday,
    required this.user,
    required this.tax1Jazafi,
    required this.tax2Mobassat,
    required this.tax3Hakiki,
    required this.tax1,
    required this.tax2,
    required this.tax3,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalUsersEnter: int.parse(json['totalUsersEnter'].toString()),
      totalGuestsEnter: int.parse(json['totalGuestsEnter'].toString()),
      totalUsersEntertoday: int.parse(json['totalUsersEntertoday'].toString()),
      totalGuestsEntertoday: int.parse(json['totalGuestsEntertoday'].toString()),
      user: int.parse(json['user'].toString()),
      tax1Jazafi: int.parse(json['tax_1_jazafi'].toString()),
      tax2Mobassat: int.parse(json['tax_2_mobassat'].toString()),
      tax3Hakiki: int.parse(json['tax_3_hakiki'].toString()),
      tax1: (json['tax1Percent'] ?? 0).toDouble(),
      tax2: (json['tax2Percent'] ?? 0).toDouble(),
      tax3: (json['tax3Percent'] ?? 0).toDouble(),
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
      "tax1Percent": tax1,
      "tax2Percent": tax2,
      "tax3Percent": tax3,
    };
  }
}