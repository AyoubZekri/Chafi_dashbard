import 'dart:io';

import 'package:chafi_dashboard/data/model/LawModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/class/Statusrequest.dart';
import '../core/functions/Snacpar copy.dart';
import '../core/functions/handlingdatacontroller.dart';
import '../core/functions/uploudfiler.dart';
import '../core/services/Services.dart';
import '../data/datasource/Remote/LawData.dart';

class Lawcontroller extends GetxController {
  String currentLang = Get.locale?.languageCode ?? 'ar';

  late TextEditingController nameAr;
  late TextEditingController index;
  late TextEditingController nameFr;
  late TextEditingController fileController;
  String? selectedFileName;
  File? file;

  late TextEditingController editNameAr;
  late TextEditingController editNameFr;
  late TextEditingController editFileController;

  Lawdata lawdata = Lawdata(Get.find());
  Myservices myServices = Get.find();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  Statusrequest statusrequest = Statusrequest.none;

  List<LawModel> data = [];
  List<LawModel> filteredData = [];
  int currentPage = 0;
  int rowsPerPage = 10;

  @override
  void onInit() {
    viewdata();
    nameAr = TextEditingController();
    nameFr = TextEditingController();
    index = TextEditingController();
    fileController = TextEditingController();

    editNameAr = TextEditingController();
    editNameFr = TextEditingController();
    editFileController = TextEditingController();

    filteredData = data;
    super.onInit();
  }

  // عرض البيانات
  Future<void> viewdata() async {
    statusrequest = Statusrequest.loadeng;
    update();

    var response = await lawdata.viewdata();
    print("Response: $response");

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        data.clear();
        List listdata = response['data'];
        data.addAll(listdata.map((e) => LawModel.fromJson(e)));
        filteredData = List.from(data);

        // print("data == $data");
        // print("filteredData == $filteredData");
      } else {
        statusrequest = Statusrequest.failure;
      }
    }

    update();
  }

  // إضافة قانون
  Future<void> adddata() async {
    if (!formState.currentState!.validate()) return;

    if (file == null) {
      showSnackbar("خطأ".tr, "يجب إضافة الملف".tr, Colors.red);
      return;
    }

    statusrequest = Statusrequest.loadeng;
    update();

    Map<String, dynamic> requestData = {
      'published_date': DateTime.now().toIso8601String(),
      'name': nameAr.text,
      'name_fr': nameFr.text,
    };

    var response = await lawdata.adddata(requestData, file!);
    print("Add Response: $response");

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      nameAr.clear();
      nameFr.clear();
      fileController.clear();
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
        'published_date': DateTime.now().toIso8601String(),
        'name': editNameAr.text,
        'name_fr': editNameFr.text,
      };
      var response = await lawdata.editdata(data, file);
      print("=====================================$response");
      statusrequest = handlingData(response);
      if (Statusrequest.success == statusrequest) {
        if (response["status"] == 1) {
          editNameAr.clear();
          editNameFr.clear();
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
      var response = await lawdata.editdata(data, file);
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

  Future<void> deletLaw(int id) async {
    statusrequest = Statusrequest.loadeng;
    update();

    var response = await lawdata.deletdata({"id": id.toString()});
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

  void setEditData(LawModel law) {
    editNameAr.text = law.name;
    editNameFr.text = law.nameFr;
    file = null;
  }

  void setIndexData(LawModel law) {
    index.text = law.index.toString();
  }

  // رفع الملف
  Future<void> uploadimagefile() async {
    final result = await fileuploadGallerys(false);

    if (result != null && result.files.single.path != null) {
      file = File(result.files.single.path!);
      fileController.text = result.files.single.name;
      update();
    }
  }

  List<LawModel> get pagedData =>
      filteredData.skip(currentPage * rowsPerPage).take(rowsPerPage).toList();

  int get totalPages => (filteredData.length / rowsPerPage).ceil();

  void filterData(String query) {
    currentPage = 0;
    filteredData = data
        .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
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
}
