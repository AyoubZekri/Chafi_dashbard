import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/class/Statusrequest.dart';
import '../core/functions/Snacpar copy.dart';
import '../core/functions/handlingdatacontroller.dart';
import '../core/services/Services.dart';
import '../data/datasource/Remote/BonusesAndCompensationsData.dart';
import '../data/model/BonusModel.dart';
import '../data/model/NatureoftheactivityModel.dart';

class Bonusesandcompensationscontroller extends GetxController {
  String currentLang = Get.locale?.languageCode ?? 'ar';

  late TextEditingController namear;
  late TextEditingController namefr;
  late TextEditingController editnamear;
  late TextEditingController editnamefr;
  late TextEditingController index;

  int? selectcats;
  int? editselectcats;

  final List<Map<String, Object>> cat = [
    {'key': 1, 'label': "الخاضعة لي الإشتراك والضريبة"},
    {'key': 2, 'label': "الخاضعة لي الضريبة"},
    {'key': 3, 'label': "غير خاضعة"},
  ];

  Bonusesandcompensationsdata bonusesandcompensationsdata =
      Bonusesandcompensationsdata(Get.find());
  Myservices myServices = Get.find();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  Statusrequest statusrequest = Statusrequest.none;

  List<BonusModel> data = [];
  List<BonusModel> filteredData = [];
  int currentPage = 0;
  int rowsPerPage = 10;

  // عرض البيانات
  Future<void> viewdata() async {
    statusrequest = Statusrequest.loadeng;
    update();

    var response = await bonusesandcompensationsdata.viewdata();
    print("Response: $response");

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        data.clear();
        List listdata = response['data'];
        data.addAll(listdata.map((e) => BonusModel.fromJson(e)));
        filteredData = List.from(data);
        print("data == $data");
        print("filteredData == $filteredData");
        if (data.isEmpty) {
          statusrequest = Statusrequest.failure;
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  // إضافة قانون
  Future<void> adddata() async {
    if (!formState.currentState!.validate()) return;
    Get.back();

    if (selectcats == null) {
      showSnackbar("خطأ".tr, "يرجى اختيار الفئة".tr, Colors.red);
      return;
    }
    statusrequest = Statusrequest.loadeng;
    update();

    Map<String, dynamic> requestData = {
      "name_ar": namear.text,
      "name_fr": namefr.text,
      "category": selectcats,
    };

    var response = await bonusesandcompensationsdata.adddata(requestData);
    print("Add Response: $response");

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      namear.clear();
      namefr.clear();
      selectcats = null;
      print("===========================");
      viewdata();
      Get.back();
    } else {
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  // update

  void editdata(int id) async {
    if (formState.currentState!.validate()) {
      Get.back();

      if (editselectcats == null) {
        showSnackbar("خطأ".tr, "يرجى اختيار الفئة".tr, Colors.red);
        return;
      }
      statusrequest = Statusrequest.loadeng;
      update();
      Map data = {
        "id": id,
        'name_ar': editnamear.text,
        'name_fr': editnamefr.text,
        "category": editselectcats,
      };
      var response = await bonusesandcompensationsdata.editdata(data);
      print("=====================================$response");
      statusrequest = handlingData(response);
      if (Statusrequest.success == statusrequest) {
        if (response["status"] == 1) {
          editnamear.clear();
          editnamefr.clear();
          Get.back();
          viewdata();
        } else {
          statusrequest = Statusrequest.failure;
        }
      }
    }

    update();
  }

  void editindex(int id) async {
    if (formState.currentState!.validate()) {
      Get.back();

      statusrequest = Statusrequest.loadeng;
      update();
      Map data = {"id": id, "index": index.text};
      var response = await bonusesandcompensationsdata.editdata(data);
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
    var response = await bonusesandcompensationsdata.deletdata({
      "id": id.toString(),
    });
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

  void setEditData(BonusModel law) {
    editnamear.text = law.nameAr;
    editnamefr.text = law.nameFr;
    editselectcats = law.category;
    print("===============${editnamear.text}");
  }

  void setIndexData(Natureoftheactivitymodel law) {
    index.text = law.index.toString();
  }

  @override
  void onInit() {
    namear = TextEditingController();
    namefr = TextEditingController();
    editnamear = TextEditingController();
    editnamefr = TextEditingController();
    index = TextEditingController();
    viewdata();

    filteredData = data;
    super.onInit();
  }

  List<BonusModel> get pagedData =>
      filteredData.skip(currentPage * rowsPerPage).take(rowsPerPage).toList();

  int get totalPages => (filteredData.length / rowsPerPage).ceil();

  void filterData(String query) {
    currentPage = 0;
    filteredData = data
        .where(
          (item) =>
              item.localizedName.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    update();
  }

  void changePage(int index) {
    currentPage = index;
    update();
  }

  void changeRowsPerPage(int count) {
    rowsPerPage = count;
    currentPage = 0;
    update();
  }

  // دالة الصفحة التالية
  void nextPage() {
    if (currentPage < totalPages - 1) {
      currentPage++;
      update();
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      currentPage--;
      update();
    }
  }
}
