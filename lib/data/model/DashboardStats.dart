class StateStats {
  final String state;
  final int dailyUser;
  final int dailyG;
  final int totalUser;
  final int totalG;
  final double dailyPercent;

  StateStats({
    required this.state,
    required this.dailyUser,
    required this.dailyG,
    required this.totalUser,
    required this.totalG,
    required this.dailyPercent,
  });

  factory StateStats.fromJson(Map<String, dynamic> json) {
    return StateStats(
      state: json['state'] ?? '',
      dailyUser: int.parse(json['dailyUser'].toString()),
      dailyG: int.parse(json['dailyG'].toString()),
      totalUser: int.parse(json['totalUser'].toString()),
      totalG: int.parse(json['totalG'].toString()),
      dailyPercent: (json['daily_percent'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'state': state,
      'dailyUser': dailyUser,
      'dailyG': dailyG,
      'totalUser': totalUser,
      'totalG': totalG,
      'daily_percent': dailyPercent,
    };
  }
}

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
  final List<StateStats> data; // ← هنا ضفنا

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
    required this.data,
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
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => StateStats.fromJson(e))
          .toList(),
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
      "data": data.map((e) => e.toJson()).toList(),
    };
  }
}