import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constant/routes.dart';
import '../../core/services/Services.dart';

class Forgenpasswordcontroller extends GetxController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  late TextEditingController name;
  late TextEditingController email;
  late TextEditingController password;
  late TextEditingController confirmPassword;

  bool issobscureText = true;
  bool issobscureText2 = true;

  void showPassword() {
    issobscureText = issobscureText == true ? false : true;
    update();
  }

  void showPassword2() {
    issobscureText2 = issobscureText2 == true ? false : true;
    update();
  }

  Myservices myServices = Get.find();
  List data = [];

  reset(){
    Get.offNamed(Approutes.login);
  }

  GoToBack() {
    Get.back();
  }

  // GoToForgenPassword() {
  //   Get.offNamed(Approutes.forgenPassword);
  // }

  @override
  void onInit() {
    // FirebaseMessaging.instance.getToken().then((value) {
    //   String? token = value;
    //   print("token:$token");
    // });
    name = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
    confirmPassword = TextEditingController();

    super.onInit();
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }
}
