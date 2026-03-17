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
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  @override
  void onInit() {
    viewdata();
    super.onInit();
  }
}
