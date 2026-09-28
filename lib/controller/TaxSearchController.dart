import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../core/class/Crud.dart';
import '../core/class/Statusrequest.dart';
import '../core/functions/Snacpar copy.dart';
import '../core/functions/handlingdatacontroller.dart';
import '../core/functions/uploudfiler.dart';
import '../data/datasource/Remote/TaxSearchData.dart';
import '../data/model/TaxSearchModel.dart';

class TaxSearchController extends GetxController {
  final titlear = TextEditingController();
  final codeController = TextEditingController();
  final titlefr = TextEditingController();
  final yearController = TextEditingController();

  final edittitlear = TextEditingController();
  final editcodeController = TextEditingController();
  final edittitlefr = TextEditingController();
  final edityearController = TextEditingController();

  final preambleController = TextEditingController();
  final editPreambleController = TextEditingController();

  final searchController = TextEditingController();

  // الملف المرفق (PDF/Word)
  final fileController = TextEditingController();
  final editFileController = TextEditingController();
  File? file;

  TaxSearchData taxSearchData = TaxSearchData(Get.find());
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  Statusrequest statusrequest = Statusrequest.none;

  List<TaxSearchModel> data = [];
  List<TaxSearchModel> filteredData = [];

  // Pagination properties
  int currentPage = 0;
  int rowsPerPage = 10;
  int get totalPages => (filteredData.length / rowsPerPage).ceil();
  List<TaxSearchModel> get pagedData {
    int start = currentPage * rowsPerPage;
    int end = start + rowsPerPage;
    return filteredData.sublist(
        start, end > filteredData.length ? filteredData.length : end);
  }

  void setEditData(TaxSearchModel item) {
    edittitlear.text = item.titleAr;
    editcodeController.text = item.code;
    edittitlefr.text = item.titleFr ?? '';
    edityearController.text = item.year?.toString() ?? '';
    editPreambleController.text = item.bodyAr ?? '';
    file = null;
    editFileController.text = item.file == null ? '' : item.file!.split('/').last;
  }

  Future<void> pickFile({required bool edit}) async {
    final result = await fileuploadGallerys(false);
    if (result != null && result.files.single.path != null) {
      file = File(result.files.single.path!);
      (edit ? editFileController : fileController).text =
          result.files.single.name;
      update();
    }
  }

  Future<void> viewdata() async {
    statusrequest = Statusrequest.loadeng;
    update();

    var response = await taxSearchData.viewdata({});
    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1 || response["status"] == true) {
        data.clear();
        List listdata = response['data'];
        data.addAll(listdata.map((e) => TaxSearchModel.fromJson(e)));
        filteredData = List.from(data);
        if (filteredData.isEmpty) {
          statusrequest = Statusrequest.failure;
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  Future<void> adddata() async {
    if (!formState.currentState!.validate()) return;
    Get.back();
    statusrequest = Statusrequest.loadeng;
    update();

    Map<String, dynamic> requestData = {
      "code": codeController.text,
      "title_ar": titlear.text,
      "title_fr": titlefr.text,
      "year": yearController.text,
      "preamble": preambleController.text,
    };

    Crud.lastError = null;
    var response = await taxSearchData.adddata(requestData, file);
    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success && (response["status"] == 1 || response["status"] == true)) {
      titlear.clear();
      codeController.clear();
      titlefr.clear();
      yearController.clear();
      preambleController.clear();
      fileController.clear();
      file = null;
      viewdata();
      showSnackbar("نجاح".tr, "تمت الإضافة بنجاح".tr, Colors.green);
    } else {
      showSnackbar("خطأ".tr, _failMessage(response, "فشلت الإضافة"), Colors.red);
    }
    update();
  }

  Future<void> editdata(int id) async {
    if (!formState.currentState!.validate()) return;
    Get.back();
    statusrequest = Statusrequest.loadeng;
    update();

    Map<String, dynamic> requestData = {
      "id": id.toString(),
      "code": editcodeController.text,
      "title_ar": edittitlear.text,
      "title_fr": edittitlefr.text,
      "year": edityearController.text,
      "preamble": editPreambleController.text,
    };

    Crud.lastError = null;
    var response = await taxSearchData.editdata(requestData, file);
    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success && (response["status"] == 1 || response["status"] == true)) {
      edittitlear.clear();
      editcodeController.clear();
      edittitlefr.clear();
      edityearController.clear();
      editPreambleController.clear();
      editFileController.clear();
      file = null;
      viewdata();
      showSnackbar("نجاح".tr, "تم التعديل بنجاح".tr, Colors.green);
    } else {
      showSnackbar("خطأ".tr, _failMessage(response, "فشل التعديل"), Colors.red);
    }
    update();
  }

  Future<void> deletData(int id) async {
    var response = await taxSearchData.deletdata({"id": id.toString()});
    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success && (response["status"] == 1 || response["status"] == true)) {
      data.removeWhere((element) => element.id == id);
      filteredData = data;
      update();
      showSnackbar("نجاح".tr, "تم الحذف بنجاح".tr, Colors.green);
    } else {
      showSnackbar("خطأ".tr, "فشل الحذف".tr, Colors.red);
    }
  }

  // رسالة الباك اند إن وجدت، وإلا رسالة السيرفر (مثل 403) المستخرجة في Crud
  String _failMessage(dynamic response, String fallback) {
    if (response is Map && response["message"] != null) {
      return "${fallback.tr}: ${response["message"]}";
    }
    return Crud.lastError == null
        ? fallback.tr
        : "${fallback.tr} (${Crud.lastError})";
  }

  void filterData(String query) {
    if (query.isEmpty) {
      filteredData = List.from(data);
    } else {
      filteredData = data
          .where((element) =>
              element.titleAr.toLowerCase().contains(query.toLowerCase()) ||
              element.code.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
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
    super.onInit();
  }
}
