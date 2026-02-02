import 'package:chafi_dashboard/data/datasource/Remote/AppointmentscommitmentsData.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/class/Statusrequest.dart';
import '../core/functions/Snacpar copy.dart';
import '../core/functions/handlingdatacontroller.dart';
import '../core/services/Services.dart';
import '../data/model/AppointmentsModel.dart';

class AppointmentscommitmentscontrollerImp extends GetxController {
  // داخلAppointmentscommitmentscontrollerImp
  late TextEditingController typeAr;
  late TextEditingController typeFr;
  late TextEditingController deadline;
  late TextEditingController consequencesAr;
  late TextEditingController consequencesFr;
  late TextEditingController noticeDate;
  late TextEditingController index;

  late TextEditingController edittypeAr;
  late TextEditingController edittypeFr;
  late TextEditingController editdeadline;
  late TextEditingController editconsequencesAr;
  late TextEditingController editconsequencesFr;
  late TextEditingController editnoticeDate;

  int? selectedsestemTax;
  int? selectedfiltersestemTax = 0;

  int? editselectedsestemTax;

  final List<Map<String, Object>> sestemTax = [
    {'key': 0, 'label': "tax_flat_system".tr},
    {'key': 1, 'label': "tax_simplified_system".tr},
    {'key': 2, 'label': "tax_real_system".tr},
  ];

  Appointmentscommitmentsdata lawdata = Appointmentscommitmentsdata(Get.find());
  Myservices myServices = Get.find();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  Statusrequest statusrequest = Statusrequest.none;

  List<Appointmentsmodel> data = [];
  List<Appointmentsmodel> filteredData = [];
  int currentPage = 0;
  int rowsPerPage = 10;

  Future<void> viewdata() async {
    statusrequest = Statusrequest.loadeng;
    update();

    final requst = {
      "tax_id": selectedfiltersestemTax == 0 ? null : selectedfiltersestemTax,
    };

    var response = await lawdata.viewdata(requst);
    print("Response: $response");

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        data.clear();
        List listdata = response['data'];
        data.addAll(listdata.map((e) => Appointmentsmodel.fromJson(e)));
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

    statusrequest = Statusrequest.loadeng;
    update();

    Map<String, dynamic> requestData = {
      "tax_id": selectedsestemTax,
      "declaration": typeAr.text,
      "dependencies": consequencesAr.text,
      "declaration_fr": typeFr.text,
      "dependencies_fr": consequencesFr.text,
      "deadline": deadline.text,
      "noticeDate": noticeDate.text,
    };

    var response = await lawdata.adddata(requestData);
    print("Add Response: $response");

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      typeAr.clear();
      typeFr.clear();
      consequencesAr.clear();
      consequencesFr.clear();
      deadline.clear();
      noticeDate.clear();
      selectedsestemTax == null;
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
        "tax_id": editselectedsestemTax,
        "declaration": edittypeAr.text,
        "dependencies": editconsequencesAr.text,
        "declaration_fr": edittypeFr.text,
        "dependencies_fr": editconsequencesFr.text,
        "deadline": editdeadline.text,
        "noticeDate": editnoticeDate.text,
      };
      var response = await lawdata.editdata(data);
      print("=====================================$response");
      statusrequest = handlingData(response);
      if (Statusrequest.success == statusrequest) {
        if (response["status"] == 1) {
          edittypeAr.clear();
          edittypeFr.clear();
          editconsequencesAr.clear();
          editconsequencesFr.clear();
          editdeadline.clear();
          editnoticeDate.clear();
          editselectedsestemTax == null;
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
      var response = await lawdata.editdata(data);
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

    var response = await lawdata.deletdata({"id": id.toString()});
    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      data.removeWhere((element) => element.id == id);
      filteredData = data;
      update();

      showSnackbar("نجاح", "تم الحذف بنجاح", Colors.green);
    } else {
      showSnackbar("خطأ", "فشل الحذف", Colors.red);
    }
  }

  void setEditData(Appointmentsmodel law) {
    edittypeAr.text = law.declarationAr;
    edittypeFr.text = law.declarationFr;
    editconsequencesAr.text = law.dependenciesAr;
    editconsequencesFr.text = law.dependenciesFr;
    editdeadline.text = law.noticeDate;
    editselectedsestemTax = law.taxId;
  }

  void setIndexData(Appointmentsmodel law) {
    index.text = law.index.toString();
  }

  List<Appointmentsmodel> get pagedData =>
      filteredData.skip(currentPage * rowsPerPage).take(rowsPerPage).toList();

  int get totalPages => (filteredData.length / rowsPerPage).ceil();

  void filterData(String query) {
    currentPage = 0;
    filteredData = data
        .where(
          (item) =>
              item.declaration.toLowerCase().contains(query.toLowerCase()),
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
    typeAr = TextEditingController();
    typeFr = TextEditingController();
    deadline = TextEditingController();
    consequencesAr = TextEditingController();
    consequencesFr = TextEditingController();
    noticeDate = TextEditingController();
    index = TextEditingController();

    edittypeAr = TextEditingController();
    edittypeFr = TextEditingController();
    editdeadline = TextEditingController();
    editconsequencesAr = TextEditingController();
    editconsequencesFr = TextEditingController();
    editnoticeDate = TextEditingController();
    viewdata();
    filteredData = data;
    super.onInit();
  }
}
