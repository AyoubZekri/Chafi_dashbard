import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/class/Statusrequest.dart';
import '../core/functions/Snacpar copy.dart';
import '../core/functions/handlingdatacontroller.dart';
import '../core/services/Services.dart';
import '../data/datasource/Remote/Differentdata.dart';
import '../data/model/DifferantModel.dart';

class ExternallinkscontrollerImp extends GetxController {
  final namear = TextEditingController();
  final namefr = TextEditingController();
  final link = TextEditingController();

  final editnamear = TextEditingController();
  final editnamefr = TextEditingController();
  final editlink = TextEditingController();
  final index = TextEditingController();

  int currentPage = 0;
  int rowsPerPage = 10;

  Differentdata differentdata = Differentdata(Get.find());

  Myservices myServices = Get.find();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  Statusrequest statusrequest = Statusrequest.none;

  List<DifferentsModel> data = [];
  List<DifferentsModel> filteredData = [];

  Future<void> adddata() async {
    // if (!formState.currentState!.validate()) return;
    statusrequest = Statusrequest.loadeng;
    update();
    Map<String, dynamic> requestData = {
      "type": 2,
      "title": namear.text,
      "title_fr": namefr.text,
      "index_link": link.text,
    };

    print("=================$requestData");

    var response = await differentdata.adddata(requestData);
    print("Add Response: $response");

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      namear.clear();
      namefr.clear();
      link.clear();

      Get.back();
      viewdata();

      update();
    }
  }

  Future<void> editdata(int id) async {
    // if (!formState.currentState!.validate()) return;

    statusrequest = Statusrequest.loadeng;
    update();
    Map<String, dynamic> requestData = {
      "id": id,
      "type": 2,
      "title": editnamear.text,
      "title_fr": editnamefr.text,
      "index_link": editlink.text,
    };

    print("=================$requestData");

    var response = await differentdata.editdata(requestData);
    print("Add Response: $response");

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      editnamear.clear();
      editnamefr.clear();
      editlink.clear();

      Get.back();
      viewdata();

      update();
    }
  }

  void setEditData(DifferentsModel item) {
    editnamear.text = item.title;
    editnamefr.text = item.titleFr;
    editlink.text = item.indexLink;
  }

  void setIndexData(DifferentsModel law) {
    index.text = law.index.toString();
  }

  Future<void> viewdata() async {
    statusrequest = Statusrequest.loadeng;
    update();
    final dat = {"type": 2};

    var response = await differentdata.viewdata(dat);
    print("Response: $response");

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        data.clear();
        List listdata = response['data'];
        data.addAll(listdata.map((e) => DifferentsModel.fromJson(e)));
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

  void search(String query) {
    if (query.isEmpty) {
      filteredData = List.from(data);
    } else {
      filteredData = data
          .where(
            (element) =>
                element.title.toLowerCase().contains(query.toLowerCase()) ||
                (element.body.toLowerCase().contains(query.toLowerCase())),
          )
          .toList();
    }
    update();
  }

  void editindex(int id) async {
    if (formState.currentState!.validate()) {
      statusrequest = Statusrequest.loadeng;
      update();
      Map data = {"id": id, "index": index.text};
      var response = await differentdata.editdata(data);
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

    var response = await differentdata.deletdata({"id": id.toString()});
    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      data = data.where((element) => element.id != id).toList();
      update();

      showSnackbar("نجاح", "تم الحذف بنجاح", Colors.green);
    } else {
      showSnackbar("خطأ", "فشل الحذف", Colors.red);
    }
  }

  @override
  void onInit() {
    print("Institutions");
    viewdata();
    super.onInit();
  }

  List<DifferentsModel> get pagedData =>
      filteredData.skip(currentPage * rowsPerPage).take(rowsPerPage).toList();

  int get totalPages => (filteredData.length / rowsPerPage).ceil();

  void filterData(String query) {
    currentPage = 0;
    filteredData = data
        .where(
          (item) =>
              item.localizedName.toLowerCase().contains(query.toLowerCase()),
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
