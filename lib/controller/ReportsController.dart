import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/class/Statusrequest.dart';
import '../core/functions/Snacpar copy.dart';
import '../core/functions/handlingdatacontroller.dart';
import '../core/functions/uploudfiler.dart';
import '../core/services/Services.dart';
import '../data/datasource/Remote/PostData.dart';
import '../data/model/PostModel.dart';

abstract class Reportscontroller extends GetxController {}

class ReportscontrollerImp extends Reportscontroller {
  File? file;
  String? editfile;

  late TextEditingController searchController;
  final titlear1 = TextEditingController();
  final titlear2 = TextEditingController();
  final titlefr1 = TextEditingController();
  final titlefr2 = TextEditingController();
  final infoar = TextEditingController();
  final infofr = TextEditingController();

  final edittitlear1 = TextEditingController();
  final edittitlear2 = TextEditingController();
  final edittitlefr1 = TextEditingController();
  final edittitlefr2 = TextEditingController();
  final editinfoar = TextEditingController();
  final editinfofr = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  Postdata postdata = Postdata(Get.find());
  Myservices myServices = Get.find();
  Statusrequest statusrequest = Statusrequest.none;
  List<PostModel> data = [];
  List<PostModel> filteredData = [];

  Future<void> viewdata() async {
    statusrequest = Statusrequest.loadeng;
    update();
    final dat = {"type": 1};

    var response = await postdata.viewdata(dat);
    print("Response: $response");

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        data.clear();
        List listdata = response['data'];
        data.addAll(listdata.map((e) => PostModel.fromJson(e)));
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

  Future<void> adddata() async {
    if (!formState.currentState!.validate()) return;

    statusrequest = Statusrequest.loadeng;
    Map<String, dynamic> requestData = {
      'type': '1',
      'title': titlear1.text,
      'title2': titlear2.text,
      'body': infoar.text,
      'title_fr': titlefr1.text,
      'title2_fr': titlefr2.text,
      'body_fr': infofr.text,
    };

    print("=================$requestData");

    var response = await postdata.adddata(requestData, file!);
    print("Add Response: $response");

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      titlear1.clear();
      titlear2.clear();
      titlefr1.clear();
      titlefr2.clear();
      infoar.clear();
      infofr.clear();
      file = null;
      Get.back();
      viewdata();
    } else {
      statusrequest = Statusrequest.failure;
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

  Future<void> deletdata(int id) async {
    statusrequest = Statusrequest.loadeng;
    update();

    var response = await postdata.deletdata({"id": id.toString()});
    statusrequest = handlingData(response);
    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      data = data.where((element) => element.id != id).toList();
      update();

      showSnackbar("نجاح", "تم الحذف بنجاح", Colors.green);
    } else {
      showSnackbar("خطأ", "فشل الحذف", Colors.red);
    }
  }

  Future<void> uploadimagefile() async {
    file = await fileuploadGallery(false);
    update();
    print("=========$file");
  }

  Future<void> editData(int id) async {
    if (!formState.currentState!.validate()) return;

    statusrequest = Statusrequest.loadeng;
    Map<String, dynamic> requestData = {
      "id":id,
      'type': '1',
      'title': edittitlear1.text,
      'title2': edittitlear2.text,
      'body': editinfoar.text,
      'title_fr': edittitlefr1.text,
      'title2_fr': edittitlefr2.text,
      'body_fr': editinfofr.text,
    };

    print("=================$requestData");

    var response = await postdata.editdata(requestData, file);
    print("Edit Response: $response");

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      edittitlear1.clear();
      edittitlear2.clear();
      edittitlefr1.clear();
      edittitlefr2.clear();
      editinfoar.clear();
      editinfofr.clear();
      file = null;
      Get.back();
      viewdata();
    } else {
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  void setEditData(PostModel item) {
    edittitlear1.text = item.title;
    edittitlefr1.text = item.titleFr;
    editinfoar.text = item.body;
    editinfofr.text = item.bodyFr;
    edittitlear2.text = item.title2;
    edittitlefr2.text = item.title2Fr;
    editfile = item.image;
    file = null;
    update();
  }

  @override
  void onInit() {
    viewdata();
    super.onInit();
  }
}
