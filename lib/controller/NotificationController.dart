import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/class/Statusrequest.dart';
import '../core/functions/Snacpar copy.dart';
import '../core/functions/handlingdatacontroller.dart';
import '../core/services/Services.dart';
import '../data/datasource/Remote/NotificationData.dart';
import '../data/model/NotificationModel.dart';

class Notificationcontroller extends GetxController {
  late TextEditingController namear;
  late TextEditingController namefr;
  late TextEditingController bodyar;
  late TextEditingController bodyfr;
  late TextEditingController Timer;

  late TextEditingController editnamear;
  late TextEditingController editnamefr;
  late TextEditingController editbodyar;
  late TextEditingController editbodyfr;
  late TextEditingController editTimer;

  bool isSistem = false;
  int? selectedsestemTax;
  int? editselectedsestemTax;
  int? selectedTypeNotification;
  int? editselectedTypeNotification;

  String currentLang = Get.locale?.languageCode ?? 'ar';

  int currentPage = 0;
  int rowsPerPage = 10;

  final List<Map<String, Object>> sestemTax = [
    {'key': 0, 'label': "tax_flat_system".tr},
    {'key': 1, 'label': "tax_simplified_system".tr},
    {'key': 2, 'label': "tax_real_system".tr},
  ];

  final List<Map<String, Object>> typenotification = [
    {'key': 0, 'label': "تنبيه".tr},
    {'key': 1, 'label': "تحديث".tr},
    {'key': 2, 'label': "مهم".tr},
  ];

  Myservices myServices = Get.find();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  Statusrequest statusrequest = Statusrequest.none;
  Notificationdata notificationdata = Notificationdata(Get.find());

  List<NotificationModel> data = [];
  List<NotificationModel> filteredData = [];

  Future<void> viewdata() async {
    statusrequest = Statusrequest.loadeng;
    update();

    var response = await notificationdata.viewdata();
    print("Response: $response");

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        data.clear();
        List listdata = response['data'];
        data.addAll(listdata.map((e) => NotificationModel.fromJson(e)));
        filteredData = List.from(data);

        print("data == $data");
        print("filteredData == $filteredData");
      } else {
        statusrequest = Statusrequest.failure;
      }
    }

    update();
  }

  Future<void> adddata() async {
    if (!formState.currentState!.validate()) return;

    print("isSistem == $isSistem");
    print("selectedsestemTax == $selectedsestemTax");
    if (isSistem == true && selectedsestemTax == null) {
      showSnackbar("خطأ".tr, "يرجى اختيار النظام الضريبي".tr, Colors.red);
      return;
    }
    if (!formState.currentState!.validate()) return;
    statusrequest = Statusrequest.loadeng;
    update();

    Map<String, dynamic> requestData = {
      "title": namear.text,
      "title_fr": namefr.text,
      "content": bodyar.text,
      "content_fr": bodyfr.text,
      "type_notification": selectedTypeNotification,
      "timer": Timer.text,
      "tax_id": selectedsestemTax,
    };

    var response = await notificationdata.adddata(requestData);
    print("Add Response: $response");

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      namear.clear();
      namefr.clear();
      bodyar.clear();
      bodyfr.clear();
      selectedTypeNotification = null;
      selectedsestemTax = null;
      isSistem = false;
      viewdata();
      Get.back();
    } else {
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  // update

  void editdata(int id) async {
    if (formState.currentState!.validate()) {
      if (isSistem == true && selectedsestemTax == null) {
        showSnackbar("خطأ".tr, "يرجى اختيار النظام الضريبي".tr, Colors.red);
        return;
      }
      statusrequest = Statusrequest.loadeng;
      update();
      Map data = {
        "id": id,
        "title": editnamear.text,
        "title_fr": editnamefr.text,
        "content": editbodyar.text,
        "content_fr": editbodyfr.text,
        "type_notification": editselectedTypeNotification,
        "timer": editTimer.text,
        "tax_id": editselectedsestemTax,
      };
      var response = await notificationdata.editdata(data);
      print("=====================================$response");
      statusrequest = handlingData(response);
      if (Statusrequest.success == statusrequest) {
        if (response["status"] == 1) {
          editnamear.clear();
          editnamefr.clear();
          editbodyar.clear();
          editbodyfr.clear();
          editselectedTypeNotification = null;
          selectedsestemTax = null;
          isSistem = false;
          Get.back();
          viewdata();
        } else {
          statusrequest = Statusrequest.failure;
        }
      }
    }

    update();
  }

  Future<void> deletdata(int id) async {
    statusrequest = Statusrequest.loadeng;
    update();

    var response = await notificationdata.deletdata({"id": id.toString()});
    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      data.removeWhere((element) => element.id == id);
      filteredData = data;
      update();

      showSnackbar("نجاح".tr, "تم الحذف بنجاح".tr, Colors.green);
    } else {
      showSnackbar("خطأ".tr, "فشل الحذف".tr, Colors.red);
    }
  }

  void setEditData(NotificationModel item) {
    editnamear.text = item.title;
    editnamefr.text = item.titleFr;
    editbodyar.text = item.content;
    editbodyfr.text = item.contentFr;
    editselectedTypeNotification = item.typeNotification;
    editselectedsestemTax = item.taxId;
    isSistem = item.taxId != null ? true : false;
    editTimer.text = item.timer;
  }

  @override
  void onInit() {
    namear = TextEditingController();
    namefr = TextEditingController();
    bodyfr = TextEditingController();
    bodyar = TextEditingController();
    Timer = TextEditingController();

    editnamear = TextEditingController();
    editnamefr = TextEditingController();
    editbodyfr = TextEditingController();
    editbodyar = TextEditingController();
    editTimer = TextEditingController();
    viewdata();

    filteredData = data;
    super.onInit();
  }

  setSystemTax(int value) {
    selectedsestemTax = value;
    update();
  }

  setEditSystemTax(int value) {
    editselectedsestemTax = value;
    update();
  }

  setNotisication(int value) {
    selectedTypeNotification = value;
    update();
  }

  setEditNotisication(int value) {
    editselectedTypeNotification = value;
    update();
  }

  toggleSystem(bool value) {
    isSistem = value;
    if (!isSistem) {
      selectedsestemTax = null;
    }
    update();
  }

  List<NotificationModel> get pagedData =>
      filteredData.skip(currentPage * rowsPerPage).take(rowsPerPage).toList();

  int get totalPages => (filteredData.length / rowsPerPage).ceil();

  void filterData(String query) {
    currentPage = 0;
    filteredData = data
        .where(
          (item) =>
              item.localizedtitle.toLowerCase().contains(query.toLowerCase()) ||
              item.localizedcontent.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    update();
  }

  void changePage(int index) {
    currentPage = index;
    update();
  }

  void changeRowsPerPage(int count) {
    rowsPerPage = count;
    currentPage = 0;
    update();
  }

  // دالة الصفحة التالية
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
}
