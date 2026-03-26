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

  @override
  void onInit() {
    viewdata();
    super.onInit();
  }
}
