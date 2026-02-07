import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/class/Statusrequest.dart';
import '../core/functions/Snacpar copy.dart';
import '../core/functions/handlingdatacontroller.dart';
import '../core/services/Services.dart';
import '../data/datasource/Remote/Differentdata.dart';
import '../data/model/DifferantModel.dart';

abstract class Commonquestionscontroller extends GetxController {}

class CommonquestionscontrollerImp extends Commonquestionscontroller {
  final titlear = TextEditingController();
  final infoar = TextEditingController();
  final titlefr = TextEditingController();
  final infofr = TextEditingController();
  final index = TextEditingController();
  final searchController = TextEditingController();

  final edittitlear = TextEditingController();
  final editinfoar = TextEditingController();
  final edittitlefr = TextEditingController();
  final editinfofr = TextEditingController();
  Differentdata differentdata = Differentdata(Get.find());

  Myservices myServices = Get.find();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  Statusrequest statusrequest = Statusrequest.none;

  List<DifferentsModel> data = [];
  List<DifferentsModel> filteredData = [];

  Future<void> adddata() async {
     if (!formState.currentState!.validate()) return;

    statusrequest = Statusrequest.loadeng;
    update();
    Map<String, dynamic> requestData = {
      "type": 1,
      "title": titlear.text,
      "body": infoar.text,
      "title_fr": titlefr.text,
      "body_fr": infofr.text,
    };

    print("=================$requestData");

    var response = await differentdata.adddata(requestData);
    print("Add Response: $response");

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      titlear.clear();
      titlefr.clear();
      infoar.clear();
      infofr.clear();

      Get.back();
      viewdata();

      update();
    }
  }

  Future<void> editdata(int id) async {
     if (!formState.currentState!.validate()) return;

    statusrequest = Statusrequest.loadeng;
    update();
    Map<String, dynamic> requestData = {
      "id": id,
      "type": 1,
      "title": edittitlear.text,
      "body": editinfoar.text,
      "title_fr": edittitlefr.text,
      "body_fr": editinfofr.text,
    };

    print("=================$requestData");

    var response = await differentdata.editdata(requestData);
    print("Add Response: $response");

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      edittitlear.clear();
      edittitlefr.clear();
      editinfoar.clear();
      editinfofr.clear();

      Get.back();
      viewdata();

      update();
    }
  }

  void setEditData(DifferentsModel item) {
    edittitlear.text = item.title;
    edittitlefr.text = item.titleFr;
    editinfoar.text = item.body;
    editinfofr.text = item.bodyFr;
  }

  void setIndexData(DifferentsModel law) {
    index.text = law.index.toString();
  }

  Future<void> viewdata() async {
    statusrequest = Statusrequest.loadeng;
    update();
    final dat = {"type": 1};

    var response = await differentdata.viewdata(dat);
    print("Response: $response");

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        data.clear();
        List listdata = response['data'];
        data.addAll(listdata.map((e) => DifferentsModel.fromJson(e)));
        filteredData = List.from(data);
        if (filteredData.isEmpty) {
          statusrequest = Statusrequest.failure;
        }
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
      var response = await differentdata.editdata(data);
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

    var response = await differentdata.deletdata({"id": id.toString()});
    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      data = data.where((element) => element.id != id).toList();
      update();

      showSnackbar("نجاح".tr, "تم الحذف بنجاح".tr, Colors.green);
    } else {
      showSnackbar("خطأ".tr, "فشل الحذف".tr, Colors.red);
    }
  }

  @override
  void onInit() {
    print("Institutions");
    viewdata();
    super.onInit();
  }
}
