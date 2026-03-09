import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/class/Statusrequest.dart';
import '../../core/functions/Snacpar copy.dart';
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
    {'key': 1, 'label': "micro"},
    {'key': 2, 'label': "small"},
    {'key': 3, 'label': "medium"},
    {'key': 4, 'label': "large"},
    {'key': 5, 'label': "very_large"},
  ];

  final List<Map<String, Object>> regulated = [
    {'key': 6, 'label': "filter_innovative"},
    {'key': 7, 'label': "filter_startup"},
    {'key': 8, 'label': "filter_incubator"},
  ];

  final List<Map<String, Object>> calcelators = [
    {'key': 0, 'label': "حاسبة النظام الحقيقي", 'route': 'calPersontype'},
    {'key': 1, 'label': "حاسبة G12", 'route': 'calactivityType'},
    {'key': 2, 'label': "حاسبة G12BES", 'route': 'Typeacteviteg12bes'},
    {'key': 3, 'label': "كشف التلخيص السنوي", 'route': 'Lossorprofit'},
    {'key': 4, 'label': "الطابع الجبائي", 'route': 'Taxstamp'},
    {'key': 5, 'label': "budget_deposit", 'route': 'Inputdata'},
    {'key': 6, 'label': "gifts", 'route': 'Costsguidance'},
    {
      'key': 7,
      'label': "advertising_sponsorship",
      'route': 'Advertisingandsponsorship',
    },

    {'key': 8, 'label': "البحث والتطوير", 'route': 'Researchanddevelopment'},
    {'key': 9, 'label': "المركبات السياحية", 'route': 'Toueisttype'},
    {
      'key': 10,
      'label': "المداخيل العقارية",
      'route': 'Realestateincometype',
    },
    {
      'key': 11,
      'label': "التنازل عن العقارات",
      'route': 'Surrenderofthepropertytype',
    },

    {
      'key': 12,
      'label': "التنازل عن الإستثمار",
      'route': 'Waiverofinvestmentvalue',
    },
    {'key': 13, 'label': "bonuses_compensation", 'route': 'Accounttype'},
    {'key': 14, 'label': "ضريبة الفوائد", 'route': 'Taxtype'},
  ];

  Future<void> adddata() async {
    if (!formState.currentState!.validate()) return;

    if (isLawActive == true && selectedLaw == null) {
      showSnackbar("خطأ".tr, "يرجى اختيار القانون".tr, Colors.red);

      return;
    }

    if (isCalculatorActive == true && selectedCalculator == null) {
      showSnackbar("خطأ".tr, "يرجى اختيار الحاسبة".tr, Colors.red);
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
      "calcul": calculator?['route'],
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
