import 'package:chafi_dashboard/data/datasource/Remote/Activitydata.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/class/Statusrequest.dart';
import '../core/functions/Snacpar copy.dart';
import '../core/functions/handlingdatacontroller.dart';
import '../core/services/Services.dart';
import '../data/datasource/Remote/NatureoftheactivityData.dart';
import '../data/model/ActivitysModel.dart';
import '../data/model/NatureoftheactivityModel.dart';

class Activitiescontroller extends GetxController {
  int? selectedsestemTax;
  int? selecttypeTheActivity;
  int? statusTax;

  String currentLang = Get.locale?.languageCode ?? 'ar';

  late TextEditingController namear;
  late TextEditingController namefr;
  late TextEditingController bodyar;
  late TextEditingController bodyfr;
  late TextEditingController codeActeve;

  late TextEditingController editnamear;
  late TextEditingController editnamefr;
  late TextEditingController editbodyar;
  late TextEditingController editbodyfr;

  late TextEditingController editcodeActeve;

  late TextEditingController index;

  Myservices myServices = Get.find();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  Statusrequest statusrequest = Statusrequest.none;
  Activitydata activitydata = Activitydata(Get.find());
  Natureoftheactivitydata natureoftheactivitydata = Natureoftheactivitydata(
    Get.find(),
  );
  List<Natureoftheactivitymodel> typeActivity = [];
  List<ActivityModel> data = [];
  List<ActivityModel> filteredData = [];
  final List<Map<String, Object>> sestemTax = [
    {'key': 0, 'label': "tax_flat_system".tr},
    {'key': 1, 'label': "tax_simplified_system".tr},
    {'key': 2, 'label': "tax_real_system".tr},
  ];

  final List<Map<String, Object>> statusTaxList = [
    {'key': 1, 'label': "مستحسن".tr},
    {'key': 2, 'label': "إجباري".tr},
  ];

  int currentPage = 0;
  int rowsPerPage = 10;

  // عرض البيانات
  Future<void> viewdata() async {
    statusrequest = Statusrequest.loadeng;
    update();

    final actData = {"nataire_activitys_id": 3};

    var response = await activitydata.viewdata(actData);
    print("Response: $response");

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        data.clear();
        List listdata = response['data'];
        data.addAll(listdata.map((e) => ActivityModel.fromJson(e)));
        filteredData = List.from(data);

        print("data == $data");
        print("filteredData == $filteredData");
      } else {
        statusrequest = Statusrequest.failure;
      }
    }

    update();
  }

  Future<void> shwotypeActivity() async {
    statusrequest = Statusrequest.loadeng;
    update();

    var response = await natureoftheactivitydata.viewdata();
    print("Response: $response");

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        typeActivity.clear();
        List listdata = response['data'];
        typeActivity.addAll(
          listdata.map((e) => Natureoftheactivitymodel.fromJson(e)),
        );
        typeActivity = List.from(typeActivity);

        print("data == $data");
        print("filteredData == $filteredData");
      } else {
        statusrequest = Statusrequest.failure;
      }
    }

    update();
  }

  // إضافة قانون
  Future<void> adddata() async {
    if (!formState.currentState!.validate()) return;
    statusrequest = Statusrequest.loadeng;
    update();

    Map<String, dynamic> requestData = {
      "nataire_activitys_id": selecttypeTheActivity,
      "tax_id": selectedsestemTax,
      "status_tax": statusTax,
      "code_activity": codeActeve.text,
      "name": namear.text,
      "body": bodyar.text,
      "name_fr": namefr.text,
      "body_fr": bodyfr.text,
    };

    var response = await activitydata.adddata(requestData);
    print("Add Response: $response");

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      namear.clear();
      namefr.clear();
      bodyar.clear();
      bodyfr.clear();
      codeActeve.clear();
      selectedsestemTax = null;
      selecttypeTheActivity = null;
      statusTax = null;
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
      statusrequest = Statusrequest.loadeng;
      update();
      Map data = {
        "id": id,
        "nataire_activitys_id": selecttypeTheActivity,
        "tax_id": selectedsestemTax,
        "status_tax": statusTax,
        "code_activity": editcodeActeve.text,
        "name": editnamear.text,
        "body": editbodyar.text,
        "name_fr": editnamefr.text,
        "body_fr": editbodyfr.text,
      };
      var response = await activitydata.editdata(data);
      print("=====================================$response");
      statusrequest = handlingData(response);
      if (Statusrequest.success == statusrequest) {
        if (response["status"] == 1) {
          editnamear.clear();
          editnamefr.clear();
          editbodyar.clear();
          editbodyfr.clear();
          editcodeActeve.clear();
          selectedsestemTax = null;
          selecttypeTheActivity = null;
          statusTax = null;

          Get.back();
          viewdata();
        } else {
          statusrequest = Statusrequest.failure;
        }
      }
    }

    update();
  }

  void editindex(int id) async {
    if (formState.currentState!.validate()) {
      statusrequest = Statusrequest.loadeng;
      update();
      Map data = {"id": id, "index": index.text};
      var response = await activitydata.editdata(data);
      print("=====================================$response");
      statusrequest = handlingData(response);
      if (Statusrequest.success == statusrequest) {
        if (response["status"] == 1) {
          index.clear();
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

    var response = await activitydata.deletdata({"id": id.toString()});
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

  void setEditData(ActivityModel item) {
    editnamear.text = item.name;
    editnamefr.text = item.nameFr;
    editbodyar.text = item.name;
    editbodyfr.text = item.nameFr;
    codeActeve.text = item.nameFr;
    editcodeActeve.text = item.nameFr;
    selectedsestemTax = item.taxId;
    selecttypeTheActivity = item.nataireActivitysId;
    statusTax = item.statusTax;
  }

  void setIndexData(ActivityModel law) {
    index.text = law.index.toString();
  }

  @override
  void onInit() {
    namear = TextEditingController();
    namefr = TextEditingController();
    bodyfr = TextEditingController();
    bodyar = TextEditingController();
    codeActeve = TextEditingController();

    editnamear = TextEditingController();
    editnamefr = TextEditingController();
    editbodyfr = TextEditingController();
    editbodyar = TextEditingController();
    editcodeActeve = TextEditingController();
    index = TextEditingController();
    viewdata();
    shwotypeActivity();

    filteredData = data;
    super.onInit();
  }

  List<ActivityModel> get pagedData =>
      filteredData.skip(currentPage * rowsPerPage).take(rowsPerPage).toList();

  int get totalPages => (filteredData.length / rowsPerPage).ceil();

  void filterData(String query) {
    currentPage = 0;
    filteredData = data
        .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
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
