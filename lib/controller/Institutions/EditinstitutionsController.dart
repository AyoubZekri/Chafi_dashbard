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
  final List<Map<String, Object>> calculators = [
    {'key': 0, 'label': 'Hassba1'},
    {'key': 1, 'label': 'Hassba2'},
    {'key': 2, 'label': 'Hassba3'},
  ];

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
        ? calculators.firstWhere((c) => c['label'] == model.calcul)['key']
              as int
        : null;

    isLawActive = model.lawId != null;
    selectedLaw = model.lawId;
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
        ? calculators.firstWhere((c) => c['key'] == selectedCalculator)
        : null;

    final requestData = {
      "id": id,
      "title": titleAr.text,
      "body": infoAr.text,
      "title_fr": titleFr.text,
      "body_fr": infoFr.text,
      "law_id": law?.id,
      "calcul": calculator?['label'],
      "index_link": numPerIndex.text,
    };

    final response = await institutionData.editdata(requestData);
    statusRequest = handlingData(response);

    if (statusRequest == Statusrequest.success && response["status"] == 1) {
      clearForm();
      // العودة لصفحة Institutions
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
    type = null;
  }

  Future<void> viewLaws() async {
    statusRequest = Statusrequest.loadeng;
    update();

    final response = await lawData.viewdata();
    statusRequest = handlingData(response);

    if (statusRequest == Statusrequest.success && response["status"] == 1) {
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
