import 'package:chafi_dashboard/data/model/CategoryModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/class/Statusrequest.dart';
import '../../core/functions/Snacpar copy.dart';
import '../../core/functions/handlingdatacontroller.dart';
import '../../core/services/Services.dart';
import '../../data/datasource/Remote/Categorydata.dart';

class JoiningcategoriescontrollerImp extends GetxController {
  late TextEditingController titleAr;
  late TextEditingController titleFr;
  late TextEditingController index;

  late TextEditingController edittitleAr;
  late TextEditingController edittitleFr;

  int? selectedsestemTax;
  int? editselectedsestemTax;

  int currentPage = 0;
  int rowsPerPage = 10;

  Myservices myServices = Get.find();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  Statusrequest statusrequest = Statusrequest.none;
  Categorydata categorydata = Categorydata(Get.find());

  List<CategoryModel> data = [];
  List<CategoryModel> filteredData = [];

  final List<Map<String, Object>> sestemTax = [
    {'key': 0, 'label': "tax_flat_system".tr},
    {'key': 1, 'label': "tax_simplified_system".tr},
    {'key': 2, 'label': "tax_real_system".tr},
  ];

  // عرض البيانات
  Future<void> viewdata() async {
    statusrequest = Statusrequest.loadeng;
    update();

    final actData = {"type_cat": 1, "tax_id": selectedsestemTax ?? ""};

    var response = await categorydata.viewdata(actData);
    print("Response: $response");

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        data.clear();
        List listdata = response['data'];
        data.addAll(listdata.map((e) => CategoryModel.fromJson(e)));
        filteredData = List.from(data);

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
    if (selectedsestemTax == null) {
      showSnackbar("خطأ".tr, "يرجى اختيار النظام الضريبي".tr, Colors.red);

      return;
    }
    if (!formState.currentState!.validate()) return;
    statusrequest = Statusrequest.loadeng;
    update();

    Map<String, dynamic> requestData = {
      "tax_id": selectedsestemTax,
      "type_cat": 1,
      "name": titleAr.text,
      "name_fr": titleFr.text,
    };

    var response = await categorydata.adddata(requestData);
    print("Add Response: $response");

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      titleAr.clear();
      titleFr.clear();
      selectedsestemTax = null;
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
        "type_cat": 1,
        "name": edittitleAr.text,
        "name_fr": edittitleFr.text,
      };
      var response = await categorydata.editdata(data);
      print("=====================================$response");
      statusrequest = handlingData(response);
      if (Statusrequest.success == statusrequest) {
        if (response["status"] == 1) {
          edittitleAr.clear();
          edittitleFr.clear();
          editselectedsestemTax = null;
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
      var response = await categorydata.editdata(data);
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

    var response = await categorydata.deletdata({"id": id.toString()});
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

  void setEditData(CategoryModel item) {
    edittitleAr.text = item.name;
    edittitleFr.text = item.nameFr;
    editselectedsestemTax = item.taxId;
    update();
  }

  void setIndexData(CategoryModel law) {
    index.text = law.index.toString();
  }

  @override
  void onInit() {
    titleFr = TextEditingController();
    titleAr = TextEditingController();
    edittitleAr = TextEditingController();
    edittitleFr = TextEditingController();
    index = TextEditingController();
    viewdata();

    filteredData = data;
    super.onInit();
  }

  List<CategoryModel> get pagedData =>
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
