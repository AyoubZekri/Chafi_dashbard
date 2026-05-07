import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/class/Statusrequest.dart';
import '../core/functions/Snacpar copy.dart';
import '../core/functions/handlingdatacontroller.dart';
import '../core/services/Services.dart';
import '../data/datasource/Remote/Categorydata.dart';
import '../data/datasource/Remote/Differentdata.dart';
import '../data/model/CategoryModel.dart';
import '../data/model/DifferantModel.dart';

abstract class Differentcontroller extends GetxController {}

class DifferentcontrollerImp extends Differentcontroller {
  int selectedFilter = 0;

  late TextEditingController index;
  late TextEditingController searchController;

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  Differentdata differentdata = Differentdata(Get.find());
  Categorydata categorydata = Categorydata(Get.find());

  Myservices myServices = Get.find();
  Statusrequest statusrequest = Statusrequest.none;

  List<DifferentsModel> data = [];
  List<DifferentsModel> filteredData = [];
  List<CategoryModel> dataCategory = [
    CategoryModel(id: 0, name: "الكل", nameFr: "Tous", index: 0, typeCat: 1),
  ];

  // عرض البيانات
  Future<void> viewdata() async {
    statusrequest = Statusrequest.loadeng;
    update();
    final dat = {
      "type": 3,
      "cat_id": selectedFilter == 0 ? "" : selectedFilter,
    };

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
        print("==========================$filteredData");
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

  Future<void> viewdataCategory() async {
    update();

    final actData = {"type_cat": 1, "type": 2};

    var response = await categorydata.viewdata(actData);
    print("Response: $response");

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        List listdata = response['data'];
        dataCategory.addAll(listdata.map((e) => CategoryModel.fromJson(e)));
        dataCategory = List.from(dataCategory);
      } else {
        statusrequest = Statusrequest.failure;
      }
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

  Future<void> deletLaw(int id) async {
    var response = await differentdata.deletdata({"id": id.toString()});
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

  void setIndexData(DifferentsModel item) {
    index.text = item.index.toString();
  }

  @override
  void onInit() {
    index = TextEditingController();
    searchController = TextEditingController();
    viewdataCategory();
    viewdata();
    print("Institutions");
    super.onInit();
  }
}
