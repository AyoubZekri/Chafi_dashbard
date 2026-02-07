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

class Exclusivecontroller extends GetxController {
  File? file;
  String? editfile;

  Postdata postdata = Postdata(Get.find());

  Myservices myServices = Get.find();
  Statusrequest statusrequest = Statusrequest.none;
  List<PostModel> data = [];

  Future<void> viewdata() async {
    statusrequest = Statusrequest.loadeng;
    update();
    final dat = {"type": 2};

    var response = await postdata.viewdata(dat);
    print("Response: $response");

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success) {
      if (response["status"] == 1) {
        data.clear();
        List listdata = response['data'];
        data.addAll(listdata.map((e) => PostModel.fromJson(e)));
        data = List.from(data);
        if (data.isEmpty) {
          statusrequest = Statusrequest.failure;
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
    }

    update();
  }

  Future<void> adddata() async {

    statusrequest = Statusrequest.loadeng;

    var response = await postdata.adddata({'type': '2'}, file!);
    print("Add Response: $response");

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      file = null;
      Get.back();
      viewdata();
    } else {
      statusrequest = Statusrequest.failure;
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

      showSnackbar("نجاح".tr, "تم الحذف بنجاح".tr, Colors.green);
    } else {
      showSnackbar("خطأ".tr, "فشل الحذف".tr, Colors.red);
    }
  }

  Future<void> uploadimagefile() async {
    file = await fileuploadGallery(false);
    update();
    print("=========$file");
  }

  Future<void> editData(int id) async {
    statusrequest = Statusrequest.loadeng;
    Map<String, dynamic> requestData = {"id": id, 'type': '2'};

    print("=================$requestData");

    var response = await postdata.editdata(requestData, file);
    print("Edit Response: $response");

    statusrequest = handlingData(response);

    if (statusrequest == Statusrequest.success && response["status"] == 1) {
      file = null;
      Get.back();
      viewdata();
    } else {
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  void setEditData(PostModel item) {
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
