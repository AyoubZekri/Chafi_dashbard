import 'package:chafi_dashboard/data/datasource/Remote/Categorydata.dart';
import 'package:chafi_dashboard/data/datasource/Remote/TaxAndAppData.dart';
import 'package:chafi_dashboard/data/model/CategoryModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/class/Statusrequest.dart';
import '../../core/functions/handlingdatacontroller.dart';
import '../../core/services/Services.dart';
import '../../data/datasource/Remote/LawData.dart';
import '../../data/model/LawModel.dart';
import '../../data/model/TaxAndAppModel.dart';
import '../../view/screen/application/PartialSystemapp.dart';
import '../../view/screen/application/RealSystemapp.dart';
import '../../view/screen/application/SimplifiedSystemapp.dart';
import '../NavigationBarcontroller.dart';

abstract class Editappcontroller extends GetxController {}

class EditappcontrollerImp extends Editappcontroller {
  final titlear = TextEditingController();
  final infoar = TextEditingController();
  final titlefr = TextEditingController();
  final infofr = TextEditingController();
  final numperindex = TextEditingController();

  bool isCalculatorActive = false;
  bool isLawActive = false;
  int? selectedCalculator;
  int? selectedLaw;
  int? selectedCategory;
  int? id;
  int? type;

  final List<Map<String, Object>> calcelators = [
    {'key': 0, 'label': 'Hassba1'},
    {'key': 1, 'label': 'Hassba2'},
    {'key': 2, 'label': 'Hassba3'},
  ];


  Lawdata lawdata = Lawdata(Get.find());
  Categorydata categorydata = Categorydata(Get.find());
  Taxandappdata taxandappdata = Taxandappdata(Get.find());

  Myservices myServices = Get.find();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  Statusrequest statusrequest = Statusrequest.none;

  List<LawModel> datalaw = [];
  List<CategoryModel> category = [];
  

  Future<void> adddata() async {
    // if (!formState.currentState!.validate()) return;
    if (selectedCategory == null) {
      Get.snackbar("خطأ", "يرجى اختيار الفئة");
      return;
    }

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

    LawModel? law;
    Map<String, Object>? calculator;

    if (isLawActive == true) {
      law = datalaw.firstWhere((element) => element.id == selectedLaw);
    }

    if (isCalculatorActive == true) {
      calculator = calcelators.firstWhere(
        (element) => element['key'] == selectedCalculator,
      );
    }

    Map<String, dynamic> requestData = {
      "cat_id": selectedCategory,
      "title": titlear.text,
      "body": infoar.text,
      "title_fr": titlefr.text,
      "body_fr": infofr.text,
      "law_id": law?.id,
      "calcul": calculator?['label'],
      "index_link": numperindex.text,
    };

    print("=================$requestData");

    var response = await taxandappdata.adddata(requestData);
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
      selectedLaw = null;
      selectedCategory = null;
      Get.find<NavigationBarcontrollerImp>().changeSubPage(
        type == 0
            ? 1
            : type == 1
                ? 2
                : 3,
        () => type == 1
            ? Simplifiedsystemapp()
            : type == 0
                ? Partialsystemapp()
                : Realsystemapp(),
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
        datalaw.clear();
        List listdata = response['data'];
        datalaw.addAll(listdata.map((e) => LawModel.fromJson(e)));
        datalaw = List.from(datalaw);

        // print("data == $data");
        // print("filteredData == $filteredData");
      } else {
        statusrequest = Statusrequest.failure;
      }
    }

    update();
  }

  Future<void> viewdataCategory() async {
    update();

    final actData = {"type_cat": 2, "tax_id": type};

    var response = await categorydata.viewdata(actData);
    print("Response: $response");

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        category.clear();
        List listdata = response['data'];
        category.addAll(listdata.map((e) => CategoryModel.fromJson(e)));
        category = List.from(category);

        print("category == $category");
      } else {
        statusrequest = Statusrequest.failure;
      }
    }

    update();
  }

  void fillDataFromModel(Taxandappmodel model) {
    id = model.id;
    titlear.text = model.title;
    infoar.text = model.body;
    titlefr.text = model.titleFr;
    infofr.text = model.bodyFr;
    numperindex.text = model.indexLink;
    isCalculatorActive = model.calcul != null;
    selectedCalculator = isCalculatorActive
        ? calcelators.firstWhere((c) => c['label'] == model.calcul)['key']
              as int
        : null;

    isLawActive = model.lawId != null;
    selectedLaw = model.lawId;
    selectedCategory = model.catId;
    

    update();
  }

  @override
  void onInit() {
    viewdata();
    viewdataCategory();
    super.onInit();
  }
}
