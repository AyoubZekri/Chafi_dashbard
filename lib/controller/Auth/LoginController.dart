import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constant/routes.dart';
import '../../core/services/Services.dart';

class Logincontroller extends GetxController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  late TextEditingController email;
  late TextEditingController password;
  bool issobscureText = true;
  void showPassword() {
    issobscureText = issobscureText == true ? false : true;
    update();
  }

  Myservices myServices = Get.find();
  List data = [];

  login() {
    Get.offNamed(Approutes.sidbar);
  }

  GoToSignUp() {
    Get.offNamed(Approutes.signup);
  }

  GoToForgenPassword() {
    Get.toNamed(Approutes.forgenPassword);
  }

  @override
  void onInit() {
    // FirebaseMessaging.instance.getToken().then((value) {
    //   String? token = value;
    //   print("token:$token");
    // });

    email = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
