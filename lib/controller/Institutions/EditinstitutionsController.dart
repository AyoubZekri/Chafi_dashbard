import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/class/Statusrequest.dart';
import '../../core/functions/Snacpar copy.dart';
import '../../core/functions/handlingdatacontroller.dart';
import '../../data/datasource/Remote/LawData.dart';
import '../../data/datasource/Remote/institution.dart';
import '../../data/model/InstitutionModel.dart';
import '../../data/model/LawModel.dart';
import '../../view/screen/Institutions.dart';
import '../../view/screen/Regulated.dart';
import '../NavigationBarcontroller.dart';

class EditinstitutionscontrollerImp extends GetxController {
  final titleAr = TextEditingController();
  final infoAr = TextEditingController();
  final titleFr = TextEditingController();
  final infoFr = TextEditingController();
  final numPerIndex = TextEditingController();
  int? id;
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  bool isCalculatorActive = false;
  bool isLawActive = false;
  int? selectedCalculator;
  int? selectedInstitutions;
  int? selectedLaw;
  int? type;

  Lawdata lawData = Lawdata(Get.find());
  InstitutionData institutionData = InstitutionData(Get.find());

  Statusrequest statusRequest = Statusrequest.none;
  List<LawModel> laws = [];

  // القوائم الثابتة
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
    {'key': 10, 'label': "المداخيل العقارية", 'route': 'Realestateincometype'},
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

  final List<Map<String, Object>> institutions = [
    {'key': 1, 'label': "micro"},
    {'key': 2, 'label': "small"},
    {'key': 3, 'label': "medium"},
    {'key': 4, 'label': "large"},
    // {'key': 5, 'label': "very_large"},
  ];

  final List<Map<String, Object>> regulated = [
    {'key': 6, 'label': "filter_innovative"},
    {'key': 7, 'label': "filter_startup"},
    {'key': 8, 'label': "filter_incubator"},
  ];

  void fillDataFromModel(InstitutionModel model) {
    id = model.id;
    titleAr.text = model.title;
    infoAr.text = model.body;
    titleFr.text = model.titleFr;
    infoFr.text = model.bodyFr;
    numPerIndex.text = model.indexLink ?? '';
    selectedInstitutions = model.scope;
    type = model.typeInstitution;
    isCalculatorActive = model.calcul != null;
    selectedCalculator = isCalculatorActive
        ? calcelators.firstWhere((c) => c['route'] == model.calcul)['key']
              as int
        : null;

    isLawActive = model.lawId != null;
    selectedLaw = model.lawId;
    print("=====================$type");
    update();
  }

  Future<void> editData() async {
    if (!formState.currentState!.validate()) return;

    if (isLawActive == true && selectedLaw == null) {
      showSnackbar("خطأ".tr, "يرجى اختيار القانون".tr, Colors.red);

      return;
    }

    if (isCalculatorActive == true && selectedCalculator == null) {
      showSnackbar("خطأ".tr, "يرجى اختيار الحاسبة".tr, Colors.red);
      return;
    }

    statusRequest = Statusrequest.loadeng;
    update();

    final law = isLawActive
        ? laws.firstWhere((element) => element.id == selectedLaw)
        : null;
    final calculator = isCalculatorActive
        ? calcelators.firstWhere((c) => c['key'] == selectedCalculator)
        : null;

    final requestData = {
      "id": id,
      "title": titleAr.text,
      "body": infoAr.text,
      "title_fr": titleFr.text,
      "body_fr": infoFr.text,
      "law_id": law?.id,
      "calcul": calculator?['route'],
      "index_link": numPerIndex.text,
    };

    final response = await institutionData.editdata(requestData);
    statusRequest = handlingData(response);

    if (statusRequest == Statusrequest.success && response["status"] == 1) {
      print("====================0$type");
      clearForm();
      Get.find<NavigationBarcontrollerImp>().changeSubPage(
        type == 1 ? 0 : 1,
        () => type == 1 ? Institutions() : Regulated(),
      );
    } else {
      statusRequest = Statusrequest.failure;
    }

    update();
  }

  void clearForm() {
    titleAr.clear();
    infoAr.clear();
    titleFr.clear();
    infoFr.clear();
    numPerIndex.clear();

    selectedCalculator = null;
    selectedInstitutions = null;
    selectedLaw = null;
    isCalculatorActive = false;
    isLawActive = false;
  }

  Future<void> viewLaws() async {
    statusRequest = Statusrequest.loadeng;
    update();

    final response = await lawData.viewdata();
    statusRequest = handlingData(response);

    if (statusRequest == Statusrequest.success && response["status"] == 1) {
      laws.clear();
      laws = List<LawModel>.from(
        response['data'].map((e) => LawModel.fromJson(e)),
      );
    }

    update();
  }

  @override
  void onInit() {
    super.onInit();
    viewLaws();
  }
}
