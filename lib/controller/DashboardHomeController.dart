import 'package:get/get.dart';

import '../core/class/Statusrequest.dart';
import '../core/functions/handlingdatacontroller.dart';
import '../core/services/Services.dart';
import '../data/datasource/Remote/statsdata.dart';
import '../data/model/DashboardStats.dart';

class Dashboardhomecontroller extends GetxController {
  Statsdata statsdata = Statsdata(Get.find());

  Myservices myServices = Get.find();
  Statusrequest statusrequest = Statusrequest.none;

  List<DashboardStats> data = [];
  List<StateStats> filteredData = [];
  List<StateStats> alldata = [];

  int currentPage = 0;
  int rowsPerPage = 10;

  Future<void> viewdata() async {
    statusrequest = Statusrequest.loadeng;
    update();
    var response = await statsdata.viewdata();
    print("Response: $response");
    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        data.clear();
        var item = DashboardStats.fromJson(response['data']);
        data.add(item);
        alldata = item.data;
        filteredData = List.from(alldata);
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  List<StateStats> get pagedData =>
      filteredData.skip(currentPage * rowsPerPage).take(rowsPerPage).toList();

  int get totalPages => (filteredData.length / rowsPerPage).ceil();

  void filterData(String query) {
    currentPage = 0;
    if (query.isEmpty) {
      filteredData = List.from(alldata);
    } else {
      filteredData = alldata
          .where(
            (item) => item.state.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }

    update();
  }

  void nextPage() {
    if (currentPage < totalPages - 1) {
      currentPage++;
      update();
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      currentPage--;
      update();
    }
  }

  String usersGuestsFilter = 'daily';
  String statsFilter = 'daily';

  List<ChartUsersGuestsDataPoint> get currentUsersGuestsData {
    if (data.isEmpty) return [];
    var group = data[0].chartUsersGuestsData;
    List<ChartUsersGuestsDataPoint> rawData;
    switch (usersGuestsFilter) {
      case 'daily':
        rawData = group.daily;
        break;
      case 'weekly':
        rawData = group.weekly;
        break;
      case 'monthly':
        rawData = group.monthly;
        break;
      case 'yearly':
        rawData = group.yearly;
        break;
      default:
        rawData = group.daily;
    }

    if (rawData.isEmpty) return [];

    int padCount = 0;
    if (usersGuestsFilter == 'daily') padCount = 7;
    else if (usersGuestsFilter == 'weekly') padCount = 4;
    else if (usersGuestsFilter == 'monthly') padCount = 6;
    else if (usersGuestsFilter == 'yearly') padCount = 3;

    if (rawData.length < padCount) {
      List<ChartUsersGuestsDataPoint> paddedData = [];
      String lastDateStr = rawData.last.date;
      
      for (int i = padCount - 1; i >= 0; i--) {
        String targetDateStr = _calculatePreviousPeriod(lastDateStr, usersGuestsFilter, i);
        var existing = rawData.firstWhere(
          (element) => element.date == targetDateStr,
          orElse: () => ChartUsersGuestsDataPoint(date: targetDateStr, usersCount: 0, guestsCount: 0),
        );
        paddedData.add(existing);
      }
      return paddedData;
    }

    return rawData;
  }

  List<ChartStatsDataPoint> get currentStatsData {
    if (data.isEmpty) return [];
    var group = data[0].chartStatsData;
    List<ChartStatsDataPoint> rawData;
    switch (statsFilter) {
      case 'daily':
        rawData = group.daily;
        break;
      case 'weekly':
        rawData = group.weekly;
        break;
      case 'monthly':
        rawData = group.monthly;
        break;
      case 'yearly':
        rawData = group.yearly;
        break;
      default:
        rawData = group.daily;
    }

    if (rawData.isEmpty) return [];

    int padCount = 0;
    if (statsFilter == 'daily') padCount = 7;
    else if (statsFilter == 'weekly') padCount = 4;
    else if (statsFilter == 'monthly') padCount = 6;
    else if (statsFilter == 'yearly') padCount = 3;

    if (rawData.length < padCount) {
      List<ChartStatsDataPoint> paddedData = [];
      String lastDateStr = rawData.last.date;
      
      for (int i = padCount - 1; i >= 0; i--) {
        String targetDateStr = _calculatePreviousPeriod(lastDateStr, statsFilter, i);
        var existing = rawData.firstWhere(
          (element) => element.date == targetDateStr,
          orElse: () => ChartStatsDataPoint(date: targetDateStr, type1: 0, type2: 0, type3: 0, type4: 0),
        );
        paddedData.add(existing);
      }
      return paddedData;
    }

    return rawData;
  }

  String _calculatePreviousPeriod(String lastDateStr, String filter, int subtractCount) {
    try {
      if (filter == 'daily' || (filter == 'weekly' && lastDateStr.contains('-') && lastDateStr.split('-').length == 3)) {
        DateTime date = DateTime.parse(lastDateStr);
        return date.subtract(Duration(days: subtractCount * (filter == 'weekly' ? 7 : 1))).toString().split(' ')[0];
      } else if (filter == 'monthly') {
        // Format: YYYY-MM
        int year = int.parse(lastDateStr.split('-')[0]);
        int month = int.parse(lastDateStr.split('-')[1]);
        int totalMonths = year * 12 + (month - 1) - subtractCount;
        int newYear = totalMonths ~/ 12;
        int newMonth = (totalMonths % 12) + 1;
        return "$newYear-${newMonth.toString().padLeft(2, '0')}";
      } else if (filter == 'yearly') {
        // Format: YYYY
        int year = int.parse(lastDateStr);
        return (year - subtractCount).toString();
      } else if (filter == 'weekly' && lastDateStr.contains('W')) {
        // Format: YYYY-W1
        var parts = lastDateStr.split('-W');
        int year = int.parse(parts[0]);
        int week = int.parse(parts[1]);
        int newWeek = week - subtractCount;
        while (newWeek <= 0) {
          year--;
          newWeek += 52;
        }
        return "$year-W$newWeek";
      }
    } catch (e) {
      print("Error calculating previous period: $e");
    }
    return lastDateStr;
  }

  void changeUsersGuestsFilter(String filter) {
    usersGuestsFilter = filter;
    update();
  }

  void changeStatsFilter(String filter) {
    statsFilter = filter;
    update();
  }

  @override
  void onInit() {
    if (data.isNotEmpty) {
      alldata = data[0].data;
      filteredData = List.from(alldata);
    }
    viewdata();
    super.onInit();
  }
}
