import 'package:chafi_dashboard/data/datasource/Remote/Categorydata.dart';
import 'package:chafi_dashboard/data/datasource/Remote/TaxAndAppData.dart';
import 'package:chafi_dashboard/data/model/CategoryModel.dart';
import 'package:chafi_dashboard/data/model/TaxAndAppModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/class/Statusrequest.dart';
import '../../core/functions/Snacpar copy.dart';
import '../../core/functions/handlingdatacontroller.dart';
import '../../core/services/Services.dart';

class RealsytemappcontrollerImp extends GetxController {
  int selectedFilter = 0;
  String currentLang = Get.locale?.languageCode ?? 'ar';
  late TextEditingController index;
  late TextEditingController searchController;

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  Taxandappdata taxandappdata = Taxandappdata(Get.find());
  Categorydata categorydata = Categorydata(Get.find());

  Myservices myServices = Get.find();
  Statusrequest statusrequest = Statusrequest.none;

  List<Taxandappmodel> data = [];
  List<Taxandappmodel> filteredData = [];
  List<CategoryModel> dataCategory = [
    CategoryModel(
      id: 0,
      name: "الكل",
      nameFr: "Tous",
      index: 0,
      taxId: 2,
      typeCat: 2,
    ),
  ];

  // عرض البيانات
  Future<void> viewdata() async {
    statusrequest = Statusrequest.loadeng;
    update();
    final dat = {
      "tax_id": 2,
      "type_cat": 2,
      "cat_id": selectedFilter == 0 ? "" : selectedFilter,
    };

    var response = await taxandappdata.viewdata(dat);
    print("Response: $response");

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        data.clear();
        List listdata = response['data'];
        data.addAll(listdata.map((e) => Taxandappmodel.fromJson(e)));
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

    final actData = {"type_cat": 2, "tax_id": 2};

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
      var response = await taxandappdata.editdata(data);
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

    var response = await taxandappdata.deletdata({"id": id.toString()});
    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      data = data.where((element) => element.id != id).toList();
      update();

      showSnackbar("نجاح".tr, "تم الحذف بنجاح".tr, Colors.green);
    } else {
      showSnackbar("خطأ".tr, "فشل الحذف".tr, Colors.red);
    }
  }

  void setIndexData(Taxandappmodel item) {
    index.text = item.index.toString();
  }

  @override
  void onInit() {
    index = TextEditingController();
    searchController = TextEditingController();
    viewdata();
    viewdataCategory();
    super.onInit();
  }
}
