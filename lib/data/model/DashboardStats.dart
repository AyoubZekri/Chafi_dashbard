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
      dailyUser: int.parse((json['dailyUser'] ?? 0).toString()),
      dailyG: int.parse((json['dailyG'] ?? 0).toString()),
      totalUser: int.parse((json['totalUser'] ?? 0).toString()),
      totalG: int.parse((json['totalG'] ?? 0).toString()),
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

class ChartStatsDataPoint {
  final String date;
  final int type1;
  final int type2;
  final int type3;
  final int type4;

  ChartStatsDataPoint({
    required this.date,
    required this.type1,
    required this.type2,
    required this.type3,
    required this.type4,
  });

  factory ChartStatsDataPoint.fromJson(Map<String, dynamic> json) {
    return ChartStatsDataPoint(
      date: json['date'] ?? '',
      type1: int.parse((json['type_1'] ?? 0).toString()),
      type2: int.parse((json['type_2'] ?? 0).toString()),
      type3: int.parse((json['type_3'] ?? 0).toString()),
      type4: int.parse((json['type_4'] ?? 0).toString()),
    );
  }
}

class ChartUsersGuestsDataPoint {
  final String date;
  final int usersCount;
  final int guestsCount;

  ChartUsersGuestsDataPoint({
    required this.date,
    required this.usersCount,
    required this.guestsCount,
  });

  factory ChartUsersGuestsDataPoint.fromJson(Map<String, dynamic> json) {
    return ChartUsersGuestsDataPoint(
      date: json['date'] ?? '',
      usersCount: int.parse((json['users_count'] ?? 0).toString()),
      guestsCount: int.parse((json['guests_count'] ?? 0).toString()),
    );
  }
}

class ChartGroup<T> {
  final List<T> daily;
  final List<T> weekly;
  final List<T> monthly;
  final List<T> yearly;

  ChartGroup({
    required this.daily,
    required this.weekly,
    required this.monthly,
    required this.yearly,
  });

  factory ChartGroup.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return ChartGroup(
      daily: (json['daily'] as List? ?? []).map((e) => fromJsonT(e)).toList(),
      weekly: (json['weekly'] as List? ?? []).map((e) => fromJsonT(e)).toList(),
      monthly:
          (json['monthly'] as List? ?? []).map((e) => fromJsonT(e)).toList(),
      yearly: (json['yearly'] as List? ?? []).map((e) => fromJsonT(e)).toList(),
    );
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
  final int totalIns;
  final int totalTax;
  final int totalCard;
  final int totalCal;
  final int dailyIns;
  final int dailyTax;
  final int dailyCard;
  final int dailyCal;
  final List<StateStats> data;
  final ChartGroup<ChartStatsDataPoint> chartStatsData;
  final ChartGroup<ChartUsersGuestsDataPoint> chartUsersGuestsData;

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
    required this.totalIns,
    required this.totalTax,
    required this.totalCard,
    required this.totalCal,
    required this.dailyIns,
    required this.dailyTax,
    required this.dailyCard,
    required this.dailyCal,
    required this.data,
    required this.chartStatsData,
    required this.chartUsersGuestsData,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalUsersEnter: int.parse((json['totalUsersEnter'] ?? 0).toString()),
      totalGuestsEnter: int.parse((json['totalGuestsEnter'] ?? 0).toString()),
      totalUsersEntertoday: int.parse((json['totalUsersEntertoday'] ?? 0).toString()),
      totalGuestsEntertoday:
          int.parse((json['totalGuestsEntertoday'] ?? 0).toString()),
      user: int.parse((json['user'] ?? 0).toString()),
      tax1Jazafi: int.parse((json['tax_1_jazafi'] ?? 0).toString()),
      tax2Mobassat: int.parse((json['tax_2_mobassat'] ?? 0).toString()),
      tax3Hakiki: int.parse((json['tax_3_hakiki'] ?? 0).toString()),
      tax1: (json['tax1Percent'] ?? 0).toDouble(),
      tax2: (json['tax2Percent'] ?? 0).toDouble(),
      tax3: (json['tax3Percent'] ?? 0).toDouble(),
      totalIns: int.parse((json['totalIns'] ?? 0).toString()),
      totalTax: int.parse((json['totalTax'] ?? 0).toString()),
      totalCard: int.parse((json['totalCard'] ?? 0).toString()),
      totalCal: int.parse((json['totalCal'] ?? 0).toString()),
      dailyIns: int.parse((json['dailyIns'] ?? 0).toString()),
      dailyTax: int.parse((json['dailyTax'] ?? 0).toString()),
      dailyCard: int.parse((json['dailyCard'] ?? 0).toString()),
      dailyCal: int.parse((json['dailyCal'] ?? 0).toString()),
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => StateStats.fromJson(e))
          .toList(),
      chartStatsData: ChartGroup.fromJson(
        json['chart_stats_data'] ?? {},
        (e) => ChartStatsDataPoint.fromJson(e),
      ),
      chartUsersGuestsData: ChartGroup.fromJson(
          json['chart_users_guests_data'] ?? {},
          (j) => ChartUsersGuestsDataPoint.fromJson(j)),
    );
  }

  factory DashboardStats.mock() {
    return DashboardStats(
      totalUsersEnter: 1500,
      totalGuestsEnter: 450,
      totalUsersEntertoday: 45,
      totalGuestsEntertoday: 12,
      user: 1250,
      tax1Jazafi: 120,
      tax2Mobassat: 85,
      tax3Hakiki: 45,
      tax1: 40.0,
      tax2: 30.0,
      tax3: 30.0,
      totalIns: 850,
      totalTax: 1200,
      totalCard: 3200,
      totalCal: 5400,
      dailyIns: 25,
      dailyTax: 40,
      dailyCard: 110,
      dailyCal: 180,
      data: [
        StateStats(
            state: "الجزائر",
            dailyUser: 10,
            dailyG: 5,
            totalUser: 200,
            totalG: 100,
            dailyPercent: 15),
        StateStats(
            state: "وهران",
            dailyUser: 8,
            dailyG: 3,
            totalUser: 150,
            totalG: 80,
            dailyPercent: 12),
      ],
      chartStatsData: ChartGroup(
        daily: List.generate(
            8,
            (i) => ChartStatsDataPoint(
                date: "2026-05-${i + 1}",
                type1: 10 + i * 2,
                type2: 5 + i,
                type3: 8 + i * 3,
                type4: 2 + i)),
        weekly: List.generate(
            8,
            (i) => ChartStatsDataPoint(
                date: "2026-W${i + 1}",
                type1: 50 + i * 10,
                type2: 30 + i * 5,
                type3: 40 + i * 8,
                type4: 10 + i * 2)),
        monthly: List.generate(
            8,
            (i) => ChartStatsDataPoint(
                date: "2026-0${i + 1}",
                type1: 200 + i * 50,
                type2: 150 + i * 30,
                type3: 180 + i * 40,
                type4: 50 + i * 10)),
        yearly: List.generate(
            8,
            (i) => ChartStatsDataPoint(
                date: "${2020 + i}",
                type1: 2000 + i * 500,
                type2: 1500 + i * 300,
                type3: 1800 + i * 400,
                type4: 500 + i * 100)),
      ),
      chartUsersGuestsData: ChartGroup(
        daily: List.generate(
            8,
            (i) => ChartUsersGuestsDataPoint(
                date: "2026-05-${i + 1}",
                usersCount: 50 + i * 10,
                guestsCount: 20 + i * 5)),
        weekly: List.generate(
            8,
            (i) => ChartUsersGuestsDataPoint(
                date: "2026-W${i + 1}",
                usersCount: 300 + i * 100,
                guestsCount: 120 + i * 50)),
        monthly: List.generate(
            8,
            (i) => ChartUsersGuestsDataPoint(
                date: "2026-0${i + 1}",
                usersCount: 1500 + i * 500,
                guestsCount: 400 + i * 200)),
        yearly: List.generate(
            8,
            (i) => ChartUsersGuestsDataPoint(
                date: "${2020 + i}",
                usersCount: 8000 + i * 2000,
                guestsCount: 2000 + i * 800)),
      ),
    );
  }
}