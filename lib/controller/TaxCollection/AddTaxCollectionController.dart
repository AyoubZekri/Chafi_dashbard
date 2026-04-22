import 'package:chafi_dashboard/data/datasource/Remote/Categorydata.dart';
import 'package:chafi_dashboard/data/datasource/Remote/TaxAndAppData.dart';
import 'package:chafi_dashboard/data/model/CategoryModel.dart';
import 'package:chafi_dashboard/view/screen/TaxCollection/SimplifiedSystem.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/class/Statusrequest.dart';
import '../../core/functions/Snacpar copy.dart';
import '../../core/functions/handlingdatacontroller.dart';
import '../../core/services/Services.dart';
import '../../data/datasource/Remote/LawData.dart';
import '../../data/model/LawModel.dart';
import '../../view/screen/TaxCollection/PartialSystem.dart';
import '../../view/screen/TaxCollection/RealSystem.dart';
import '../NavigationBarcontroller.dart';

abstract class Addtaxcollectioncontroller extends GetxController {}

class AddtaxcollectioncontrollerImp extends Addtaxcollectioncontroller {
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

  int? type;

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

  Lawdata lawdata = Lawdata(Get.find());
  Categorydata categorydata = Categorydata(Get.find());
  Taxandappdata taxandappdata = Taxandappdata(Get.find());

  Myservices myServices = Get.find();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  Statusrequest statusrequest = Statusrequest.none;

  List<LawModel> data = [];
  List<CategoryModel> category = [];

  List<Map<String, dynamic>> lawsList = [];

  void addLaw() {
    lawsList.add({
      "law_id": null,
      "name_ar": "",
      "name_fr": "",
      "index_link": null,
    });
    update();
  }

  void updateLawId(int index, int? value) {
    lawsList[index]['law_id'] = value;
    update();
  }

  void removeLaw(int index) {
    lawsList.removeAt(index);
    update();
  }

  void updateLawIndex(int index, String value) {
    lawsList[index]['index_link'] = int.tryParse(value);
    update();
  }

  void updateLawNameAr(int index, String value) {
    lawsList[index]['name_ar'] = value;
    update();
  }

  void updateLawNameFr(int index, String value) {
    lawsList[index]['name_fr'] = value;
    update();
  }

  Future<void> adddata() async {
    if (!formState.currentState!.validate()) return;
    if (selectedCategory == null) {
      showSnackbar("خطأ".tr, "يرجى اختيار الفئة".tr, Colors.red);
      return;
    }

    if (isLawActive == true && lawsList.isEmpty) {
      showSnackbar("خطأ".tr, "يرجى إضافة قانون واحد على الأقل".tr, Colors.red);
      return;
    }

    if (isCalculatorActive == true && selectedCalculator == null) {
      showSnackbar("خطأ".tr, "يرجى اختيار الحاسبة".tr, Colors.red);
      return;
    }

    statusrequest = Statusrequest.loadeng;
    update();

    // LawModel? law;
    Map<String, Object>? calculator;

    // if (isLawActive == true) {
    //   law = data.firstWhere((element) => element.id == selectedLaw);
    // }

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
      // "law_id": law?.id,
      "calcul": calculator?['route'],
      "laws": lawsList,

      // "index_link": numperindex.text,
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
      lawsList.clear();
      Get.find<NavigationBarcontrollerImp>().changeSubPage(
        type == 0
            ? 1
            : type == 1
            ? 2
            : 3,
        () => type == 1
            ? Simplifiedsystem()
            : type == 0
            ? Partialsystem()
            : Realsystem(),
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

  Future<void> viewdataCategory() async {
    print("========0$type");
    update();

    final actData = {"type_cat": 1, "tax_id": type};

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

  @override
  void onInit() {
    viewdata();
    super.onInit();
  }
}
