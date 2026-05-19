import 'package:chafi_dashboard/data/datasource/Remote/institution.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/class/Statusrequest.dart';
import '../core/functions/Snacpar copy.dart';
import '../core/functions/handlingdatacontroller.dart';
import '../core/services/Services.dart';
import '../data/datasource/Remote/Categorydata.dart';
import '../data/model/CategoryModel.dart';
import '../data/model/InstitutionModel.dart';

abstract class Institutionscontroller extends GetxController {}

class InstitutionscontrollerImp extends Institutionscontroller {
  String currentLang = Get.locale?.languageCode ?? 'ar';
  late TextEditingController index;
  late TextEditingController searchController;
  int selectedFilter = 0;

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  final List<Map<String, Object>> filters = [
    {'key': 0, 'label': ' all'},
    {'key': 1, 'label': 'micro'},
    {'key': 2, 'label': 'small'},
    {'key': 3, 'label': 'medium'},
    {'key': 4, 'label': 'large'},
    // {'key': 5, 'label': 'very_large'},
  ];

  InstitutionData institutionData = InstitutionData(Get.find());
  Categorydata categorydata = Categorydata(Get.find());

  Myservices myServices = Get.find();
  Statusrequest statusrequest = Statusrequest.none;

  List<InstitutionModel> data = [];
  List<InstitutionModel> filteredData = [];
  List<CategoryModel> category = [
    CategoryModel(
      id: 0,
      name: "الكل",
      nameFr: "Tous",
      index: 0,
      taxId: 0,
      typeCat: 2,
    ),
  ];
  List<CategoryModel> childCategory = [
    CategoryModel(
      id: 0,
      name: "الكل",
      nameFr: "Tous",
      index: 0,
      taxId: 0,
      typeCat: 2,
    ),
  ];
  int? selectedCategory = 0;
  int? selectedchildCategory = 0;

  Future<void> viewdataCategory() async {
    update();
    final actData = {"type_cat": 1, 'type': 3};

    var response = await categorydata.viewdata(actData);

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        category = [
          CategoryModel(
            id: 0,
            name: "الكل",
            nameFr: "Tous",
            index: 0,
            taxId: 0,
            typeCat: 2,
          ),
        ];
        List listdata = response['data'];
        category.addAll(listdata.map((e) => CategoryModel.fromJson(e)));
        category = List.from(category);
      } else {
        statusrequest = Statusrequest.failure;
      }
    }

    update();
  }

  Future<void> viewChildCategory() async {
    update();
    final actData = {
      "cat_id": selectedCategory == 0 ? "" : selectedCategory,
      'type': 4,
    };

    var response = await categorydata.viewdata(actData);
    print("===============Response================: $response");
    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        childCategory = [
          CategoryModel(
            id: 0,
            name: "الكل",
            nameFr: "Tous",
            index: 0,
            taxId: 0,
            typeCat: 2,
          ),
        ];
        List listdata = response['data'];
        childCategory.addAll(listdata.map((e) => CategoryModel.fromJson(e)));
        childCategory = List.from(childCategory);
      } else {
        statusrequest = Statusrequest.failure;
      }
    }

    update();
  }

  // عرض البيانات
  Future<void> viewdata() async {
    statusrequest = Statusrequest.loadeng;
    update();
    final dat = {
      // "scope": selectedFilter,
      // "type_institution": 1,
      "cat_id": selectedchildCategory == 0 ? null : selectedchildCategory,
      "parints_cat": selectedCategory == 0 ? null : selectedCategory,
    };

    var response = await institutionData.viewdata(dat);
    print("Response: $response");

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        data.clear();
        List listdata = response['data'];
        data.addAll(listdata.map((e) => InstitutionModel.fromJson(e)));
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

  void editindex(int id) async {
    if (formState.currentState!.validate()) {
      statusrequest = Statusrequest.loadeng;
      update();
      Map data = {"id": id, "index": index.text};
      var response = await institutionData.editdata(data);
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
    var response = await institutionData.deletdata({"id": id.toString()});
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

  void setIndexData(InstitutionModel item) {
    index.text = item.index.toString();
  }

  @override
  void onInit() {
    index = TextEditingController();
    searchController = TextEditingController();
    viewdata();
    viewdataCategory();
    print("Institutions");
    super.onInit();
  }
}
