import 'package:chafi_dashboard/data/datasource/Remote/institution.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/class/Statusrequest.dart';
import '../core/functions/Snacpar copy.dart';
import '../core/functions/handlingdatacontroller.dart';
import '../core/services/Services.dart';
import '../data/model/InstitutionModel.dart';

abstract class Institutionscontroller extends GetxController {}

class InstitutionscontrollerImp extends Institutionscontroller {
  String currentLang = Get.locale?.languageCode ?? 'ar';
  late TextEditingController index;
  late TextEditingController searchController;
  int selectedFilter = 0;

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  final List<Map<String, Object>> filters = [
    {'key': 0, 'label': ' all'.tr},
    {'key': 1, 'label': 'micro'.tr},
    {'key': 2, 'label': 'small'.tr},
    {'key': 3, 'label': 'medium'.tr},
    {'key': 4, 'label': 'large'.tr},
    {'key': 5, 'label': 'very_large'.tr},
  ];

  InstitutionData institutionData = InstitutionData(Get.find());
  Myservices myServices = Get.find();
  Statusrequest statusrequest = Statusrequest.none;

  List<InstitutionModel> data = [];
  List<InstitutionModel> filteredData = [];

  // عرض البيانات
  Future<void> viewdata() async {
    statusrequest = Statusrequest.loadeng;
    update();
    final dat = {"scope": selectedFilter, "type_institution": 1};

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
    statusrequest = Statusrequest.loadeng;
    update();

    var response = await institutionData.deletdata({"id": id.toString()});
    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      data = data.where((element) => element.id != id).toList();
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
    print("Institutions");
    super.onInit();
  }
}
