import 'package:chafi_dashboard/data/datasource/Remote/UsersData.dart';
import 'package:chafi_dashboard/data/model/UsersModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/class/Statusrequest.dart';
import '../core/constant/FeedbackQuestions.dart';
import '../core/functions/Snacpar copy.dart';
import '../core/functions/handlingdatacontroller.dart';
import '../core/services/Services.dart';

class Userscontroller extends GetxController {
  Usersdata usersdata = Usersdata(Get.find());
  Myservices myServices = Get.find();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  Statusrequest statusrequest = Statusrequest.none;
  // أسئلة الاستبيان (مشتركة مع صفحة مقارنة الآراء)
  List<Map<String, dynamic>> get questions => feedbackQuestions();
  List<UserModel> data = [];
  List<UserModel> filteredData = [];
  int currentPage = 0;
  int rowsPerPage = 10;

  Future<void> viewdata() async {
    statusrequest = Statusrequest.loadeng;
    update();

    var response = await usersdata.viewdata();
    print("Response: $response");

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        data.clear();
        List listdata = response['data'];
        data.addAll(listdata.map((e) => UserModel.fromJson(e)));
        filteredData = List.from(data);

        print("data == $data");
        print("filteredData == $filteredData");
        if (data.isEmpty) {
          statusrequest = Statusrequest.failure;
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
    }

    update();
  }

  /// حذف مستخدم مع كل بياناته (من السيرفر ثم من الجدول)
  Future<void> deletdata(int id) async {
    var response = await usersdata.deletdata(id);
    if (handlingData(response) == Statusrequest.success &&
        response["status"] == 1) {
      data.removeWhere((u) => u.id == id);
      filteredData.removeWhere((u) => u.id == id);
      // إذا فرغت الصفحة الحالية نرجع للصفحة السابقة
      if (currentPage > 0 && currentPage >= totalPages) currentPage--;
      update();
      showSnackbar("نجاح".tr, "تم الحذف بنجاح".tr, Colors.green);
    } else {
      showSnackbar("خطأ".tr, "فشل الحذف".tr, Colors.red);
    }
  }

  List<UserModel> get pagedData =>
      filteredData.skip(currentPage * rowsPerPage).take(rowsPerPage).toList();

  int get totalPages => (filteredData.length / rowsPerPage).ceil();

  void filterData(String query) {
    currentPage = 0;
    filteredData = data
        .where(
          (item) =>
              item.username.toLowerCase().contains(query.toLowerCase()) ||
              item.email.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    update();
  }

  void changePage(int pageIndex) {
    currentPage = pageIndex;
    update();
  }

  void changeRowsPerPage(int count) {
    rowsPerPage = count;
    currentPage = 0;
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
    filteredData = data;
    super.onInit();
  }
}
