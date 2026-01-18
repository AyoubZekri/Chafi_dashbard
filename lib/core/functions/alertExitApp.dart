import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/Colorapp.dart';

Future<bool> alertExitApp() {
  Get.defaultDialog(
    backgroundColor: AppColor.white,
    title: "Alert".tr,
    titleStyle: const TextStyle(
        fontWeight: FontWeight.bold, color: AppColor.black),
    middleText: "هل تريد الخروج من التطبيق".tr,
    onConfirm: () {
      exit(0);
    },
    onCancel: () {
      Get.back();
    },
    buttonColor: AppColor.primarycolor,
    confirmTextColor: AppColor.white,
    cancelTextColor: AppColor.primarycolor,
  );
  return Future.value(true);
}
