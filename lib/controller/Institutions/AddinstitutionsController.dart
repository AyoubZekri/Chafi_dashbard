import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/class/Statusrequest.dart';
import '../../core/functions/handlingdatacontroller.dart';
import '../../core/services/Services.dart';
import '../../data/datasource/Remote/LawData.dart';
import '../../data/datasource/Remote/institution.dart';
import '../../data/model/LawModel.dart';
import '../../view/screen/Institutions.dart';
import '../../view/screen/Regulated.dart';
import '../NavigationBarcontroller.dart';

class AddinstitutionscontrollerImp extends GetxController {
  final titlear = TextEditingController();
  final infoar = TextEditingController();
  final titlefr = TextEditingController();
  final infofr = TextEditingController();
  final numperindex = TextEditingController();

  bool isCalculatorActive = false;
  bool isLawActive = false;
  int? selectedCalculator;
  int? selectedinstitutions;

  int? selectedLaw;
  int? type;

  Lawdata lawdata = Lawdata(Get.find());
  InstitutionData institutionData = InstitutionData(Get.find());

  Myservices myServices = Get.find();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  Statusrequest statusrequest = Statusrequest.none;

  List<LawModel> data = [];

  final List<Map<String, Object>> institutions = [
    {'key': 1, 'label': "micro".tr},
    {'key': 2, 'label': "small".tr},
    {'key': 3, 'label': "medium".tr},
    {'key': 4, 'label': "large".tr},
    {'key': 5, 'label': "very_large".tr},
  ];

  final List<Map<String, Object>> regulated = [
    {'key': 6, 'label': "filter_innovative".tr},
    {'key': 7, 'label': "filter_startup".tr},
    {'key': 8, 'label': "filter_incubator".tr},
  ];

  final List<Map<String, Object>> calcelators = [
    {'key': 0, 'label': 'Hassba1'},
    {'key': 1, 'label': 'Hassba2'},
    {'key': 2, 'label': 'Hassba3'},
  ];

  Future<void> adddata() async {
    // if (!formState.currentState!.validate()) return;

    if (isLawActive == true && selectedLaw == null) {
      Get.snackbar("خطأ", "يرجى اختيار القانون");
      return;
    }

    if (isCalculatorActive == true && selectedCalculator == null) {
      Get.snackbar("خطأ", "يرجى اختيار الحاسبة");
      return;
    }

    statusrequest = Statusrequest.loadeng;
    update();

    // تعريف المتغيرات مسبقًا
    LawModel? law;
    Map<String, Object>? calculator;

    if (isLawActive == true) {
      law = data.firstWhere((element) => element.id == selectedLaw);
    }

    if (isCalculatorActive == true) {
      calculator = calcelators.firstWhere(
        (element) => element['key'] == selectedCalculator,
      );
    }

    Map<String, dynamic> requestData = {
      "type_institution": type,
      "scope": selectedinstitutions,
      "title": titlear.text,
      "body": infoar.text,
      "title_fr": titlefr.text,
      "body_fr": infofr.text,
      "law_id": law?.id,
      "calcul": calculator?['label'],
      "index_link": numperindex.text,
    };

    print("=================$requestData");

    var response = await institutionData.adddata(requestData);
    print("Add Response: $response");

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      titlear.clear();
      titlefr.clear();
      infoar.clear();
      infofr.clear();
      isLawActive = false;
      isCalculatorActive = false;
      selectedCalculator = null;
      selectedinstitutions = null;
      selectedLaw = null;
      // العودة لصفحة Institutions
      Get.find<NavigationBarcontrollerImp>().changeSubPage(
        type == 1 ? 0 : 1,
        () => type == 1 ? Institutions() : Regulated(),
      );
    } else {
      statusrequest = Statusrequest.failure;
    }

    update();
  }

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
        data = List.from(data);

        // print("data == $data");
        // print("filteredData == $filteredData");
      } else {
        statusrequest = Statusrequest.failure;
      }
    }

    update();
  }

  @override
  void onInit() {
    print("===================$type");
    viewdata();
    super.onInit();
  }
}
