import 'package:chafi_dashboard/data/datasource/Remote/UsersData.dart';
import 'package:chafi_dashboard/data/model/UsersModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/class/Statusrequest.dart';
import '../core/functions/handlingdatacontroller.dart';
import '../core/services/Services.dart';

class Userscontroller extends GetxController {
  Usersdata usersdata = Usersdata(Get.find());
  Myservices myServices = Get.find();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  Statusrequest statusrequest = Statusrequest.none;
  List<Map<String, dynamic>> get questions => [
    {
      "title": "العدالة الضريبية".tr,
      "options": [
        {"id": 11, "name": "ضعيفة".tr},
        {"id": 12, "name": "مقبولة".tr},
        {"id": 13, "name": "جيدة ومحفزة".tr},
      ],
    },
    {
      "title": "العلاقة مع الادارة".tr,
      "options": [
        {"id": 21, "name": "متعاونة".tr},
        {"id": 22, "name": "بطيئة".tr},
        {"id": 23, "name": "صارمة ومعقدة".tr},
      ],
    },
    {
      "title": "عوائق الامتثال".tr,
      "options": [
        {"id": 31, "name": "تعقيد القوانين الجبائية".tr},
        {"id": 32, "name": "ارتفاع تكلفة الضرائب".tr},
        {"id": 33, "name": "غياب التوجيه".tr},
      ],
    },
    {
      "title": "الدافع نحو الامتثال".tr,
      "options": [
        {"id": 41, "name": "واجب وطني".tr},
        {"id": 42, "name": "الاستفادة من التحفيزات".tr},
        {"id": 43, "name": "تجنب العقوبات".tr},
      ],
    },
    {
      "title": "أثر الرقمنة".tr,
      "options": [
        {"id": 51, "name": "ضرورة للعمل".tr},
        {"id": 52, "name": "توفر الوقت والجهد".tr},
        {"id": 53, "name": "صعبة الاستخدام".tr},
      ],
    },
    {
      "title": "كيف ساعدك شافي".tr,
      "options": [
        {"id": 61, "name": "بسط القوانين الجبائية".tr},
        {"id": 62, "name": "صحح المفاهيم الخاطئة".tr},
        {"id": 63, "name": "قلل كلفة الاستشارة".tr},
        {"id": 64, "name": "تعزيز وتحفيز على الامتثال".tr},
      ],
    },
  ];
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
